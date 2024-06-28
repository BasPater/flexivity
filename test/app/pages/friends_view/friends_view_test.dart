import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/friends_view/friends_view.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/day_activity.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friend.dart';
import 'package:flexivity/data/models/friend_request.dart';
import 'package:flexivity/data/models/friendship.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/responses/get_friend_request_response.dart';
import 'package:flexivity/data/models/responses/get_friendships_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/friend/friend_repository.dart';
import 'package:flexivity/presentation/friends_view_model/friends_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'friends_view_test.mocks.dart';

Friend testFriend1 = Friend(
    1,
    // userId
    'friend1@email.com',
    // email
    'testFriend1',
    // userName
    'Friend1',
    // firstName
    'One',
    // lastName
    'friend',
    // role
    DayActivity(1000, 200) // activity
    );

Friend testFriend2 = Friend(
    2,
    // userId
    'friend2@email.com',
    // email
    'testFriend2',
    // userName
    'Friend2',
    // firstName
    'Two',
    // lastName
    'friend',
    // role
    DayActivity(2000, 300) // activity
    );

Friendship testFriendship1 = Friendship(
    1, // friendshipId
    testFriend1, // friend
    FriendshipStatus.accepted, // status
    1, // actionUserId
    DateTime.now(), // createdAt
    DateTime.now() // updatedAt
    );

Friendship testFriendship2 = Friendship(
    2, // friendshipId
    testFriend2, // friend
    FriendshipStatus.pending, // status
    2, // actionUserId
    DateTime.now(), // createdAt
    DateTime.now() // updatedAt
    );

@GenerateNiceMocks([MockSpec<FriendRepository>(), MockSpec<FriendsViewModel>()])
void main() {
  MockFriendRepository mockFriendRepository = MockFriendRepository();
  MockFriendsViewModel mockFriendsViewModel = MockFriendsViewModel();
  FriendsViewModel viewModel =
      FriendsViewModel(friendRepo: mockFriendRepository);
  FriendsViewModel mockedViewModel = MockFriendsViewModel();

  setUp(() {
    reset(mockFriendsViewModel);
    reset(mockFriendRepository);
    viewModel = FriendsViewModel(friendRepo: mockFriendRepository);
    viewModel.friendsList = [testFriend1, testFriend2];
  });

  testWidgets('FriendsScreen renders correctly', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: FriendsViewModel(
        friendRepo: mockFriendRepository,
      ),
    ));

    expect(find.byType(UIStateSwitcher), findsOneWidget);
  });

  test('FriendsViewModel fetches friends correctly', () async {
    when(mockFriendRepository.getFriends(any)).thenAnswer(
        (_) async => GetFriendshipResponse([testFriendship1, testFriendship2]));

    viewModel.friendsList = [];

    await viewModel.updateFriendList();

    expect(viewModel.friendsList, [testFriend1]);
    expect(viewModel.uiState, UIState.normal);
  });

  test('FriendsViewModel fetches friend requests correctly', () async {
    when(mockFriendRepository.getFriends(any)).thenAnswer(
      (_) async => GetFriendshipResponse([testFriendship1, testFriendship2]),
    );

    when(mockFriendRepository.getFriendRequests(any)).thenAnswer(
      (_) async => GetFriendRequestResponse(
        [
          FriendRequest(
            actionUserId: 0,
            createdAt: DateTime.now(),
            friend: User(0, '', '', '', '', ''),
            friendshipId: 0,
            status: FriendshipStatus.pending,
            updatedAt: DateTime.now(),
          ),
        ],
      ),
    );

    viewModel.friendsList = [];

    await viewModel.updateFriendList();
    expect(Globals.friendNotificationsCount, 1);

    Globals.friendNotificationsCount = 0;
  });

  test('FriendsViewModel fetches friends incorrectly', () async {
    when(mockFriendRepository.getFriends(any))
        .thenThrow(const ApiException(''));

    viewModel.friendsList = [];

    await viewModel.updateFriendList();

    expect(viewModel.friendsList, []);
    expect(viewModel.uiState, UIState.error);
  });

  test('FriendsViewModel fetches friends correctly but the array is empty',
      () async {
    when(mockFriendRepository.getFriends(any))
        .thenAnswer((_) async => GetFriendshipResponse([]));

    viewModel.friendsList = [];

    await viewModel.updateFriendList();

    expect(viewModel.friendsList, []);
    expect(viewModel.uiState, UIState.empty);
  });

  test('FriendsViewModel removes a friend correctly', () async {
    when(mockFriendRepository.deleteFriend(any)).thenAnswer((_) async => true);

    try {
      await viewModel.removeFriend(testFriend1);
      // If the function call doesn't throw an exception, the test will pass.
    } catch (e) {
      fail('viewModel.removeFriend(testFriend1) threw an exception: $e');
    }
  });

  test('FriendsViewModel removes a friend correctly with UIState Empty',
      () async {
    when(mockFriendRepository.deleteFriend(any)).thenAnswer((_) async => true);
    viewModel.friendsList = [];

    await viewModel.removeFriend(testFriend1);

    expect(viewModel.uiState, UIState.empty);
  });

  test('FriendsViewModel removes a friend incorrectly', () async {
    when(mockFriendRepository.deleteFriend(any)).thenAnswer((_) async => false);

    expect(() => viewModel.removeFriend(testFriend1),
        throwsA(isA<ApiException>()));
  });

  test('FriendsViewModel removes a friend incorrectly', () async {
    when(mockFriendRepository.deleteFriend(any))
        .thenThrow(const ApiException(''));

    expect(() => viewModel.removeFriend(testFriend1),
        throwsA(isA<ApiException>()));
  });

  testWidgets(
      'FriendsContent renders correctly and calls getFriendsById on refresh',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: FriendsContent(
        viewModel: mockedViewModel,
        setParent: () {},
      ),
    ));

    await tester.fling(
        find.byType(RefreshIndicator), const Offset(0, 300), 3000);
    await tester.pumpAndSettle();

    verify(mockedViewModel.updateFriendList()).called(1);
    expect(find.byType(FriendsContent), findsOneWidget);
  });

  testWidgets('Dismissible widget in FriendsContent works correctly',
      (WidgetTester tester) async {
    viewModel.friendsList = [testFriend1];

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: FriendsContent(
        viewModel: viewModel,
        setParent: () {},
      ),
    )));

    // Swipe the dismissible widget to trigger the dismiss action
    await tester.drag(find.byType(Dismissible), const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Remove'));
    await tester.pumpAndSettle();

    // Verify that the removeFriend method was called
    verify(mockFriendRepository.deleteFriend(any)).called(1);
  });
}

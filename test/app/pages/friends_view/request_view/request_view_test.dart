import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/friends_view/request_view/request_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friend_request.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/responses/get_friend_request_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/friend/friend_repository.dart';
import 'package:flexivity/presentation/friends_view_model/request_view_model/request_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'request_view_test.mocks.dart';

User testUser = User(
    1, // userId
    'testuser@email.com', // email
    'testUser', // userName
    'Test', // firstName
    'User', // lastName
    'USER' // role
    );

FriendRequest testGetFriendRequestResponse = FriendRequest(
  friendshipId: 1,
  friend: testUser,
  status: FriendshipStatus.pending,
  actionUserId: 1,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

@GenerateNiceMocks([
  MockSpec<FriendRepository>(),
  MockSpec<Globals>(),
  MockSpec<RequestViewModel>()
])
void main() {
  MockFriendRepository mockFriendRepository = MockFriendRepository();
  RequestViewModel viewModel =
      RequestViewModel(friendRepo: mockFriendRepository);

  setUp(() {
    mockFriendRepository = MockFriendRepository();
    viewModel = RequestViewModel(friendRepo: mockFriendRepository);
  });

  testWidgets('RequestViewModel renders correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: RequestViewModel(friendRepo: mockFriendRepository),
    ));

    // Verify that AddFriendViewModel is shown.
    expect(find.byType(RequestViewModel), findsOneWidget);
  });

  group('getFriendRequests', () {
    test('getFriendRequests should work', () async {
      when(mockFriendRepository.getFriendRequests(any)).thenAnswer(
          (realInvocation) async =>
              GetFriendRequestResponse([testGetFriendRequestResponse]));
      await viewModel.getFriendRequests();

      expect(viewModel.uiState, UIState.normal);
      expect(viewModel.requests.length, 1);
    });

    test('getFriendRequests should work with empty response', () async {
      when(mockFriendRepository.getFriendRequests(any))
          .thenAnswer((realInvocation) async => GetFriendRequestResponse([]));
      await viewModel.getFriendRequests();

      expect(viewModel.uiState, UIState.empty);
      expect(viewModel.requests.length, 0);
    });

    test('getFriendRequests should work error', () async {
      when(mockFriendRepository.getFriendRequests(any))
          .thenThrow(const ApiException('Failed'));
      await viewModel.getFriendRequests();

      expect(viewModel.uiState, UIState.error);
      expect(viewModel.requests.length, 0);
    });
  });

  group('respondFriendRequest', () {
    test('respondFriendRequest should work', () async {
      when(mockFriendRepository.respondFriendRequest(any))
          .thenAnswer((realInvocation) async => true);
      viewModel.requests.add(testGetFriendRequestResponse);
      expect(viewModel.requests.length, 1);

      await viewModel.respondFriendRequest(true, testGetFriendRequestResponse);

      expect(viewModel.requests.length, 0);
    });

    test('respondFriendRequest throw error', () async {
      when(mockFriendRepository.respondFriendRequest(any))
          .thenThrow(const ApiException('failed'));
      viewModel.requests.add(testGetFriendRequestResponse);
      expect(viewModel.requests.length, 1);

      expectLater(
          viewModel.respondFriendRequest(true, testGetFriendRequestResponse),
          throwsA(isA<ApiException>()));

      expect(viewModel.requests.length, 1);
    });
  });

  testWidgets('RequestViewModel renders requests', (WidgetTester tester) async {
    viewModel.requests = [testGetFriendRequestResponse];
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: RequestContent(
        viewModel: viewModel,
      ),
    )));

    await tester.pumpAndSettle();
    var widget = await find.text(
        '${viewModel.requests[0].friend.firstName} ${viewModel.requests[0].friend.lastName}');

    expect(widget, findsOneWidget);
  });

  testWidgets('RequestViewModel renders requests', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: RequestContent(
        viewModel: viewModel,
      ),
    )));

    var widget = await find.text(
        '${testGetFriendRequestResponse.friend.firstName} ${testGetFriendRequestResponse.friend.lastName}');
    await tester.pumpAndSettle();
    expect(widget, findsNothing);

    // Ensure the RefreshIndicator is in the tree
    expect(find.byType(RefreshIndicator), findsOneWidget);

    // Simulate the drag gesture to pull down the RefreshIndicator
    await tester.fling(
        find.byType(RefreshIndicator), const Offset(0, 500), 1000);

    when(mockFriendRepository.getFriendRequests(any)).thenAnswer(
        (realInvocation) async =>
            GetFriendRequestResponse([testGetFriendRequestResponse]));

    widget = await find.text(
        '${testGetFriendRequestResponse.friend.firstName} ${testGetFriendRequestResponse.friend.lastName}');

    await tester.pumpAndSettle();

    expect(widget, findsOneWidget);
  });

  testWidgets('updateFriend method test', (WidgetTester tester) async {
    // Arrange
    final mockViewModel = MockRequestViewModel();
    final friendRequest = FriendRequest(
      friendshipId: 1,
      friend: testUser,
      status: FriendshipStatus.pending,
      actionUserId: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Act
    when(mockViewModel.respondFriendRequest(true, friendRequest))
        .thenAnswer((_) async => null);

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: RequestContent(
          viewModel: mockViewModel,
        ),
      ),
    ));

    // Call the method
    final state = tester.state<RequestContentState>(find.byType(RequestContent));
    await state.updateFriend(true, friendRequest);

    // Assert
    verify(mockViewModel.respondFriendRequest(true, friendRequest)).called(1);
  });

  testWidgets('updateFriend method test with ApiException', (WidgetTester tester) async {
    // Arrange
    final mockViewModel = MockRequestViewModel();
    final friendRequest = FriendRequest(
      friendshipId: 1,
      friend: testUser,
      status: FriendshipStatus.pending,
      actionUserId: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Act
    when(mockViewModel.respondFriendRequest(true, friendRequest))
        .thenThrow(ApiException('Failed'));

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: RequestContent(
          viewModel: mockViewModel,
        ),
      ),
    ));

    // Call the method
    final state = tester.state<RequestContentState>(find.byType(RequestContent));
    await state.updateFriend(true, friendRequest);

    await tester.pumpAndSettle();
    // Assert
    verify(mockViewModel.respondFriendRequest(true, friendRequest)).called(1);
    expect(find.text('Failed'), findsOneWidget);
  });
}

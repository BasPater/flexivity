import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_detail/add_members/add_members_view.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/models/basic_group.dart';
import 'package:flexivity/data/models/day_activity.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friendship.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/member.dart';
import 'package:flexivity/data/models/responses/get_friendships_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/friend/friend_repository.dart';
import 'package:flexivity/data/repositories/group/group_repository.dart';
import 'package:flexivity/presentation/groups_view_model/group_detail_view_model/add_members_view_model/add_members_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flexivity/data/models/friend.dart';
import 'package:flexivity/data/models/responses/get_group_with_activity_at_date_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_member_view_test.mocks.dart';

GetGroupWithActivityAtDateResponse testGroup =
    GetGroupWithActivityAtDateResponse(
  BasicGroup(
    1,
    "Test",
    User(1, "email@test.com", "userName1", "first", "last", "MODERATOR"),
  ),
  [
    Member(User(1, "email@test.com", "userName1", "first", "last", "MODERATOR"),
        BasicActivity(1, 1.0)),
    Member(User(2, "email1@test.com", "userName2", "first1", "last1", "USER"),
        BasicActivity(1, 1.0)),
    Member(User(3, "email2@test.com", "userName3", "first2", "last2", "USER"),
        BasicActivity(1, 1.0)),
    Member(
        User(4, "email3@test.com", "userName4", "first3", "last3", "MODERATOR"),
        BasicActivity(1, 1.0)),
    Member(User(5, "email4@test.com", "userName5", "first4", "last4", "USER"),
        BasicActivity(1, 1.0))
  ],
);

Friend testFriend1 = Friend(
    11,
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

@GenerateNiceMocks([MockSpec<GroupRepository>(), MockSpec<FriendRepository>()])
void main() {
  late AddMembersViewModel viewModel;
  late MockGroupRepository mockGroupRepo;
  late MockFriendRepository mockFriendRepo;

  setUp(() {
    mockGroupRepo = MockGroupRepository();
    mockFriendRepo = MockFriendRepository();
    viewModel = AddMembersViewModel(
      groupRepo: mockGroupRepo,
      friendRepo: mockFriendRepo,
      groupId: 1,
    );
  });

  group('AddMembersViewModel', () {
    test('getData should work as expected', () async {
      // Arrange
      when(mockGroupRepo.getGroupWithActivityAtDate(any))
          .thenAnswer((_) async => testGroup);
      when(mockFriendRepo.getFriends(any)).thenAnswer((_) async =>
          GetFriendshipResponse([testFriendship1, testFriendship2]));

      // Act
      await viewModel.getData();

      // Assert
      verify(mockGroupRepo.getGroupWithActivityAtDate(any)).called(1);
      verify(mockFriendRepo.getFriends(any)).called(1);
      expect(viewModel.uiState, UIState.normal);
    });

    test('getData should work as expected and set UIState to empty', () async {
      // Arrange
      when(mockGroupRepo.getGroupWithActivityAtDate(any))
          .thenAnswer((_) async => testGroup);
      when(mockFriendRepo.getFriends(any))
          .thenAnswer((_) async => GetFriendshipResponse([testFriendship2]));

      // Act
      await viewModel.getData();

      // Assert
      verify(mockGroupRepo.getGroupWithActivityAtDate(any)).called(1);
      verify(mockFriendRepo.getFriends(any)).called(1);
      expect(viewModel.uiState, UIState.empty);
    });

    test('getData should work as expected and set UIState to error', () async {
      // Arrange
      when(mockGroupRepo.getGroupWithActivityAtDate(any))
          .thenThrow(const ApiException("test"));
      when(mockFriendRepo.getFriends(any)).thenThrow(ApiException("test"));

      // Act
      await viewModel.getData();

      // Assert
      verify(mockGroupRepo.getGroupWithActivityAtDate(any)).called(1);
      verifyNever(mockFriendRepo.getFriends(any));
      expect(viewModel.uiState, UIState.error);
    });

    test('changeNewMembers should add and remove members correctly', () {
      // Arrange
      int userId = 1;

      // Act
      viewModel.changeNewMembers(userId);
      expect(viewModel.newMembers.contains(userId), true);

      viewModel.changeNewMembers(userId);
      expect(viewModel.newMembers.contains(userId), false);
    });

    test('addMembers should work as expected', () async {
      // Arrange
      when(mockGroupRepo.inviteGroupMembers(any, any))
          .thenAnswer((_) async => true);

      // Act
      await viewModel.addMembers();

      // Assert
      verify(mockGroupRepo.inviteGroupMembers(any, any)).called(1);
      expect(viewModel.uiState, UIState.normal);
    });

    test(
        'addMembers should work as expected and return an error when the call fails',
        () async {
      // Arrange
      when(mockGroupRepo.inviteGroupMembers(any, any))
          .thenAnswer((_) async => false);

      try {
        // Act
        await viewModel.addMembers();
      } on ApiException {
        // Assert
        verify(mockGroupRepo.inviteGroupMembers(any, any)).called(1);
        expect(viewModel.uiState, UIState.normal);
      }
    });

    test(
        'addMembers should work as expected and return an error when the call fails',
        () async {
      // Arrange
      when(mockGroupRepo.inviteGroupMembers(any, any))
          .thenThrow(const ApiException('Test'));

      try {
        // Act
        await viewModel.addMembers();
      } on ApiException {
        // Assert
        verify(mockGroupRepo.inviteGroupMembers(any, any)).called(1);
        expect(viewModel.uiState, UIState.normal);
      }
    });
  });

  group('UI', () {
    testWidgets('_getData should work as expected',
        (WidgetTester tester) async {
      // Arrange
      when(mockGroupRepo.getGroupWithActivityAtDate(any))
          .thenAnswer((_) async => testGroup);
      when(mockFriendRepo.getFriends(any)).thenAnswer((_) async =>
          GetFriendshipResponse([testFriendship2, testFriendship1]));

      // Act
      await tester.pumpWidget(MaterialApp(home: viewModel));

      // Assert
      verify(mockGroupRepo.getGroupWithActivityAtDate(any)).called(1);
      verify(mockFriendRepo.getFriends(any)).called(1);
      expect(viewModel.uiState, UIState.normal);
    });

    testWidgets('_getData should work as expected and set UIState to empty',
        (WidgetTester tester) async {
      // Arrange
      when(mockGroupRepo.getGroupWithActivityAtDate(any))
          .thenAnswer((_) async => testGroup);
      when(mockFriendRepo.getFriends(any))
          .thenAnswer((_) async => GetFriendshipResponse([testFriendship2]));

      // Act
      await tester.pumpWidget(MaterialApp(home: viewModel));

      // Assert
      verify(mockGroupRepo.getGroupWithActivityAtDate(any)).called(1);
      verify(mockFriendRepo.getFriends(any)).called(1);
      expect(viewModel.uiState, UIState.empty);
    });

    testWidgets('Scaffold should show build should work as expected',
        (WidgetTester tester) async {
      // Arrange
      when(mockGroupRepo.getGroupWithActivityAtDate(any))
          .thenAnswer((_) async => testGroup);
      when(mockFriendRepo.getFriends(any)).thenAnswer((_) async =>
          GetFriendshipResponse([testFriendship2, testFriendship1]));

      // Act
      await tester.pumpWidget(MaterialApp(home: viewModel));

      // Assert
      expect(find.text('Add members'), findsOneWidget);
      expect(find.byType(UIStateSwitcher), findsOneWidget);
    });

    testWidgets('AddMembersContent build should work as expected',
        (WidgetTester tester) async {
      viewModel.group = testGroup;
      viewModel.friendList = [testFriend1];
      viewModel.uiState = UIState.normal;

      // Act
      await tester.pumpWidget(MaterialApp(
          home: AddMembersContent(
        viewModel: viewModel,
      )));

      await tester.pump();
      // Assert
      expect(find.text(viewModel.friendList[0].getFullname()), findsOneWidget);
    });
  });
}

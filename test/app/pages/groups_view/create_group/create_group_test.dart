import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_create/group_create_view.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/models/day_activity.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/errors/http_api_exception.dart';
import 'package:flexivity/data/models/friend.dart';
import 'package:flexivity/data/models/friendship.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/responses/get_friendships_response.dart';
import 'package:flexivity/data/repositories/friend/friend_repository.dart';
import 'package:flexivity/data/repositories/group/group_repository.dart';
import 'package:flexivity/presentation/groups_view_model/group_create_view_model/group_create_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_group_test.mocks.dart';

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
    FriendshipStatus.accepted, // status
    2, // actionUserId
    DateTime.now(), // createdAt
    DateTime.now() // updatedAt
    );

@GenerateNiceMocks([MockSpec<FriendRepository>(), MockSpec<GroupRepository>(), MockSpec<GroupCreateViewModel>(), MockSpec<FormState>()])
void main() {
  group('GroupCreateViewModel', () {
    late MockFriendRepository mockFriendRepository;
    late MockGroupRepository mockGroupRepository;
    late GroupCreateViewModel viewModel;
    late MockGroupCreateViewModel mockViewModel;
    late MockFormState mockFormState;

    setUp(() {
      mockFriendRepository = MockFriendRepository();
      mockGroupRepository = MockGroupRepository();
      viewModel = GroupCreateViewModel(
          friendRepo: mockFriendRepository, groupRepo: mockGroupRepository);
      mockViewModel = MockGroupCreateViewModel();
      mockFormState = MockFormState();
    });

    group('getFriends', () {
      test(
          'getFriendsById updates friendsList and uiStateGetFriends when getFriends succeeds',
          () async {
        // Arrange
        when(mockFriendRepository.getFriends(any)).thenAnswer((_) async =>
            GetFriendshipResponse([testFriendship1, testFriendship2]));

        // Act
        await viewModel.getFriendsById();

        // Assert
        expect(viewModel.friendsList.length, 2);
        expect(viewModel.uiStateGetFriends, UIState.normal);
      });

      test(
          'getFriendsById updates uiStateGetFriends to error when getFriends throws',
          () async {
        // Arrange
        when(mockFriendRepository.getFriends(any)).thenThrow(Exception());

        // Act
        await viewModel.getFriendsById();

        // Assert
        expect(viewModel.uiStateGetFriends, UIState.error);
      });

      test('getFriendsById updates uiStateGetFriends to empty list', () async {
        // Arrange
        when(mockFriendRepository.getFriends(any))
            .thenAnswer((_) async => GetFriendshipResponse([]));

        // Act
        await viewModel.getFriendsById();

        // Assert
        expect(viewModel.uiStateGetFriends, UIState.empty);
      });
    });

    group('updateNewGroupMemberList', () {
      test(
          'updateNewGroupMemberList adds id to newGroupMemberList and returns true when id is not in the list',
          () {
        // Arrange
        int id = 1;

        // Act
        bool result = viewModel.updateNewGroupMemberList(id);

        // Assert
        expect(result, true);
        expect(viewModel.newGroupMemberList.contains(id), true);
      });

      test(
          'updateNewGroupMemberList removes id from newGroupMemberList and returns false when id is in the list',
          () {
        // Arrange
        int id = 1;
        viewModel.newGroupMemberList.add(id);

        // Act
        bool result = viewModel.updateNewGroupMemberList(id);

        // Assert
        expect(result, false);
        expect(viewModel.newGroupMemberList.contains(id), false);
      });
    });

    group('createGroup', () {
      test(
          'createGroup sets uiStateCreateGroup to normal when createGroup succeeds',
          () async {
        // Arrange
        when(mockGroupRepository.createGroup(any))
            .thenAnswer((_) async => true);

        // Act
        await viewModel.createGroup();

        // Assert
        expect(viewModel.uiStateCreateGroup, UIState.normal);
      });

      test('createGroup throws ApiException when createGroup returns false',
          () async {
        // Arrange
        when(mockGroupRepository.createGroup(any))
            .thenAnswer((_) async => false);

        // Act
        try {
          await viewModel.createGroup();
          fail('this part of the test should not be reached');
        } catch (e) {
          // Assert
          expect(e, isA<ApiException>());
        }
      });

      test(
          'createGroup catches exception, sets uiStateCreateGroup to normal and rethrows ApiException when createGroup throws',
          () async {
        // Arrange
        when(mockGroupRepository.createGroup(any))
            .thenThrow(HttpApiException('Error', 500));

        // Act
        try {
          await viewModel.createGroup();
          fail('this part of the test should not be reached');
        } catch (e) {
          // Assert
          expect(e, isA<ApiException>());
          expect(viewModel.uiStateCreateGroup, UIState.normal);
        }
      });
    });

    group('UI', () {
      testWidgets('Button and friends should appear on screen', (tester) async {
        Friend testFriend1 = Friend(1, 'friend1@email.com', 'testFriend1',
            'Friend1', 'One', 'friend', DayActivity(1000, 200));

        Friend testFriend2 = Friend(2, 'friend2@email.com', 'testFriend2',
            'Friend2', 'Two', 'friend', DayActivity(2000, 300));

        viewModel.friendsList = [testFriend1, testFriend2];
        viewModel.uiStateGetFriends = UIState.normal;

        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
          body: GroupCreateContent(
            viewModel: viewModel,
          ),
        )));

        expect(find.text('Create group'), findsOneWidget);
        expect(find.text(testFriend1.userName), findsOneWidget);
        expect(find.text(testFriend2.userName), findsOneWidget);
      });

      testWidgets('Should be able to add friends', (tester) async {
        Friend testFriend1 = Friend(1, 'friend1@email.com', 'testFriend1',
            'Friend1', 'One', 'friend', DayActivity(1000, 200));

        Friend testFriend2 = Friend(2, 'friend2@email.com', 'testFriend2',
            'Friend2', 'Two', 'friend', DayActivity(2000, 300));

        viewModel.friendsList = [testFriend1, testFriend2];
        viewModel.uiStateGetFriends = UIState.normal;

        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: GroupCreateContent(
                viewModel: viewModel,
              ),
            )));

        final checkbox = find.byType(Checkbox).first;
        await tester.tap(checkbox);
        await tester.pumpAndSettle();

        final lisTile = find.byType(ListTile).last;
        await tester.tap(lisTile);
        await tester.pumpAndSettle();

        expect(viewModel.newGroupMemberList.length, 2);

      });

      testWidgets('createGroup shows snackbar when form is invalid', (WidgetTester tester) async {
        when(mockFormState.validate()).thenReturn(false);
        when(mockViewModel.newGroupMemberList).thenReturn([]);
        when(mockViewModel.groupNameController).thenReturn(TextEditingController());


        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: GroupCreateContent(
              viewModel: mockViewModel,
            ),
          ),
        ));

        final createGroupButton = find.text('Create group');
        await tester.tap(createGroupButton);
        await tester.pumpAndSettle();

        expect(find.text('The group name cannot be empty and you must select one member for the group.'), findsOneWidget);
      });

      testWidgets('createGroup shows snackbar when createGroup succeeds', (WidgetTester tester) async {
        when(mockFormState.validate()).thenReturn(true);
        when(mockViewModel.newGroupMemberList).thenReturn([1]);
        when(mockViewModel.createGroup()).thenAnswer((_) async => completes);
        when(mockViewModel.groupNameController).thenReturn(TextEditingController(text: "test"));


        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: GroupCreateContent(
              viewModel: mockViewModel,
            ),
          ),
        ));

        final createGroupButton = find.text('Create group');
        await tester.tap(createGroupButton);
        await tester.pump();

        expect(find.text('Group created successfully. And the friends you added are also invited.'), findsOneWidget);
      });

      testWidgets('createGroup shows snackbar when createGroup fails', (WidgetTester tester) async {
        when(mockFormState.validate()).thenReturn(true);
        when(mockViewModel.newGroupMemberList).thenReturn([1]);
        when(mockViewModel.createGroup()).thenThrow(ApiException('Error'));
        when(mockViewModel.groupNameController).thenReturn(TextEditingController(text: "test"));

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: GroupCreateContent(
              viewModel: mockViewModel,
            ),
          ),
        ));

        final createGroupButton = find.text('Create group');
        await tester.tap(createGroupButton);
        await tester.pump();

        expect(find.text('Error'), findsOneWidget);
      });

      testWidgets('UiStateSwitcher should work', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: GroupCreateViewModel(
            friendRepo: mockFriendRepository,
            groupRepo: mockGroupRepository,
          ),
        ));

        when(mockFriendRepository.getFriends(any)).thenAnswer((_) async => GetFriendshipResponse([]));

        await tester.pumpAndSettle();

        expect(find.byType(UIStateSwitcher), findsOneWidget);
      });
    });
  });
}

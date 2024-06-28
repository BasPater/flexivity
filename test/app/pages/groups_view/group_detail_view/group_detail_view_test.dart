import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_detail/group_detail_view.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/basic_group.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/member.dart';
import 'package:flexivity/data/models/responses/get_group_with_activity_at_date_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/group/group_repository.dart';
import 'package:flexivity/presentation/groups_view_model/group_detail_view_model/group_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'group_detail_view_test.mocks.dart';

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

@GenerateNiceMocks([MockSpec<GroupRepository>()])
void main() {
  tearDown(() => Globals.credentials = null);

  group('Group Detail', () {
    late MockGroupRepository mockGroupRepo;
    late GroupDetailViewModel viewModel;

    setUp(() {
      mockGroupRepo = MockGroupRepository();
      viewModel = GroupDetailViewModel(
          groupId: "1", groupName: "Test", groupRepo: mockGroupRepo);
    });

    group('UI', () {
      testWidgets('UiStateSwitcher should work when no errors are thrown',
          (tester) async {
        Globals.credentials = const Credentials(0, '', '');
        when(mockGroupRepo.getGroupWithActivityAtDate(any))
            .thenAnswer((_) async => testGroup);
        var testViewModel = GroupDetailViewModel(
            groupId: "1", groupName: "Test", groupRepo: mockGroupRepo);
        await tester.pumpWidget(MaterialApp(
          home: testViewModel,
        ));
        testViewModel.userId = 1;

        await tester.pump();

        expect(find.byType(UIStateSwitcher), findsOneWidget);
        expect(testViewModel.uiState, UIState.normal);
      });

      testWidgets('UiStateSwitcher should work when errors are thrown',
          (tester) async {
        when(mockGroupRepo.getGroupWithActivityAtDate(any))
            .thenThrow(ApiException("Test"));
        var testViewModel = GroupDetailViewModel(
            groupId: "1", groupName: "Test", groupRepo: mockGroupRepo);
        await tester.pumpWidget(MaterialApp(
          home: testViewModel,
        ));

        await tester.pump();

        expect(find.byType(UIStateSwitcher), findsOneWidget);
        expect(testViewModel.uiState, UIState.error);
      });

      testWidgets('Pull to refresh should work', (tester) async {
        viewModel.groupToday = testGroup;
        await tester.pumpWidget(MaterialApp(
          home: GroupDetailContent(
            viewModel: viewModel,
            group: viewModel.groupToday,
            onRefresh: () {
              return viewModel.getGroupInformation();
            },
          ),
        ));

        await tester.fling(
            find.byType(RefreshIndicator), const Offset(0, 300), 3000);
        await tester.pumpAndSettle();

        verify(mockGroupRepo.getGroupWithActivityAtDate(any)).called(1);
      });

      testWidgets('UiStateSwitcher should work', (tester) async {
        viewModel.groupToday = testGroup;
        await tester.pumpWidget(MaterialApp(
          home: GroupDetailContent(
            viewModel: viewModel,
            group: viewModel.groupToday,
            onRefresh: () {
              return viewModel.getGroupInformation();
            },
          ),
        ));

        when(mockGroupRepo.getGroups()).thenAnswer((_) async => []);

        await tester.pumpAndSettle();

        expect(
            find.text(
                "${viewModel.groupToday?.members[0].user.firstName} ${viewModel.groupToday?.members[0].user.lastName}"),
            findsOneWidget);
        expect(
            find.text(
                "${viewModel.groupToday?.members[1].user.firstName} ${viewModel.groupToday?.members[1].user.lastName}"),
            findsOneWidget);
        expect(
            find.text(
                "${viewModel.groupToday?.members[2].user.firstName} ${viewModel.groupToday?.members[2].user.lastName}"),
            findsOneWidget);
        expect(
            find.text(
                "${viewModel.groupToday?.members[3].user.firstName} ${viewModel.groupToday?.members[3].user.lastName}"),
            findsOneWidget);
      });
    });

    group('test user roles', () {
      test('isUserModerator returns true if user is a moderator', () {
        viewModel.groupToday = testGroup;

        viewModel.userId = 1;

        expect(viewModel.isUserModerator(1), isTrue);
      });

      test('isUserModerator returns false if user is not a moderator', () {
        viewModel.groupToday = testGroup;

        viewModel.userId = 2;

        expect(viewModel.isUserModerator(2), isFalse);
      });

      test('isUserOwner returns true if user is the owner', () {
        viewModel.groupToday = testGroup;

        viewModel.userId = 1;

        expect(viewModel.isUserOwner(1), isTrue);
      });

      test('isUserOwner returns false if user is not the owner', () {
        viewModel.groupToday = testGroup;

        viewModel.userId = 2;

        expect(viewModel.isUserOwner(2), isFalse);
      });
    });

    group('admin functions', () {
      test('deleteGroup should work correctly', () async {
        when(mockGroupRepo.deleteGroup(any)).thenAnswer((_) async => true);
        await viewModel.deleteGroup();
        verify(mockGroupRepo.deleteGroup(any)).called(1);
      });

      test('deleteGroup should throw ApiException when response is false',
          () async {
        when(mockGroupRepo.deleteGroup(any)).thenAnswer((_) async => false);
        expect(viewModel.deleteGroup(), throwsA(isA<ApiException>()));
      });

      test('leaveGroup should work correctly', () async {
        when(mockGroupRepo.leaveGroup(any)).thenAnswer((_) async => true);
        await viewModel.leaveGroup();
        verify(mockGroupRepo.leaveGroup(any)).called(1);
      });

      test('leaveGroup should throw ApiException when response is false',
          () async {
        when(mockGroupRepo.leaveGroup(any)).thenAnswer((_) async => false);
        expect(viewModel.leaveGroup(), throwsA(isA<ApiException>()));
      });

      test('removeUserFromGroup should work correctly', () async {
        when(mockGroupRepo.deleteGroupMember(any, any))
            .thenAnswer((_) async => true);
        await viewModel.removeUserFromGroup(1);
        verify(mockGroupRepo.deleteGroupMember(any, any)).called(1);
      });

      test(
          'removeUserFromGroup should throw ApiException when response is false',
          () async {
        when(mockGroupRepo.deleteGroupMember(any, any))
            .thenAnswer((_) async => false);
        expect(viewModel.removeUserFromGroup(1), throwsA(isA<ApiException>()));
      });

      test('changeRole should work correctly', () async {
        when(mockGroupRepo.changeRole(any, any, any))
            .thenAnswer((_) async => true);
        await viewModel.changeRole(1, "MODERATOR");
        verify(mockGroupRepo.changeRole(any, any, any)).called(1);
      });

      test('changeRole should throw ApiException when response is false',
          () async {
        when(mockGroupRepo.changeRole(any, any, any))
            .thenAnswer((_) async => false);
        expect(
            viewModel.changeRole(1, "MODERATOR"), throwsA(isA<ApiException>()));
      });
    });
  });
}

import 'package:flexivity/app/views/groups_view/group_detail/group_manage_sheet.dart';
import 'package:flexivity/data/models/basic_group.dart';
import 'package:flexivity/data/models/member.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/group/group_repository.dart';
import 'package:flexivity/presentation/groups_view_model/group_detail_view_model/group_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flexivity/data/models/responses/get_group_with_activity_at_date_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_members/add_member_view_test.mocks.dart';

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
  late GroupDetailViewModel viewModel;
  late MockGroupRepository mockGroupRepo;

  setUp(() {
    mockGroupRepo = MockGroupRepository();
    viewModel = GroupDetailViewModel(
      groupRepo: mockGroupRepo,
      groupName: "Test",
      groupId: "1",
    );
  });
  group('UI', () {
    testWidgets('Build should work', (WidgetTester tester) async {
      // Arrange
      viewModel.groupToday = testGroup;
      viewModel.groupYesterday = testGroup;
      viewModel.userId = 1;

      // Act
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: BottomSheetManageGroup(
          viewModel: viewModel,
          setParentState: () {},
        ),
      )));

      var moreVert = find.widgetWithIcon(PopupMenuButton, Icons.more_vert);

      // Assert
      expect(find.text(viewModel.groupToday!.members[0].user.getFullname()),
          findsOneWidget);
      expect(moreVert, findsWidgets);
    });

    testWidgets('Leave group should work', (WidgetTester tester) async {
      // Arrange
      when(mockGroupRepo.leaveGroup(any)).thenAnswer((_) async => true);
      viewModel.groupToday = testGroup;
      viewModel.groupYesterday = testGroup;
      viewModel.userId = 1;

      // Act
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: BottomSheetManageGroup(
          viewModel: viewModel,
          setParentState: () {},
        ),
      )));

      // Assert
      var leaveGroupButton = find.widgetWithText(ListTile, 'Leave group');
      await tester.tap(leaveGroupButton);

      await tester.pumpAndSettle();

      var cancelButton = find.widgetWithText(TextButton, 'Leave');
      await tester.tap(cancelButton);

      await tester.pumpAndSettle();

      verify(mockGroupRepo.leaveGroup(any)).called(1);
    });

    testWidgets('Leave group should work', (WidgetTester tester) async {
      // Arrange
      when(mockGroupRepo.leaveGroup(any)).thenAnswer((_) async => true);
      viewModel.groupToday = testGroup;
      viewModel.groupYesterday = testGroup;
      viewModel.userId = 1;
      viewModel.deleteGroupController = TextEditingController(text: 'CONFIRM');

      // Act
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: BottomSheetManageGroup(
          viewModel: viewModel,
          setParentState: () {},
        ),
      )));

      // Assert
      var leaveGroupButton = find.widgetWithText(ListTile, 'Delete group');
      await tester.tap(leaveGroupButton);

      await tester.pumpAndSettle();

      var cancelButton = find.widgetWithText(TextButton, 'Delete');
      await tester.tap(cancelButton);

      tester.pumpAndSettle();

      verify(mockGroupRepo.deleteGroup(any)).called(1);
    });
  });
}

import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/empty_view/empty_view.dart';
import 'package:flexivity/app/views/groups_view/groups_view.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/basic_group.dart';
import 'package:flexivity/data/models/responses/get_group_invites.dart';
import 'package:flexivity/data/models/responses/get_group_reponse.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/group/group_repository.dart';
import 'package:flexivity/presentation/groups_view_model/groups_overview_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'groups_view_test.mocks.dart';

GetGroupResponse createTestGetGroupResponse() {
  User ownedBy = User(2, 'test@test.com', 'testuser', 'Test', 'User', 'ADMIN');
  User nr1 = User(3, 'nr1@test.com', 'nr1user', 'Nr1', 'User', 'USER');
  GetGroupResponse response =
      GetGroupResponse(1, 'Test Group', ownedBy, 1, nr1);
  return response;
}

@GenerateNiceMocks(
    [MockSpec<GroupRepository>(), MockSpec<GroupOverviewViewModel>()])
void main() {
  MockGroupRepository mockGroupRepository = MockGroupRepository();
  GroupOverviewViewModel viewModel =
      GroupOverviewViewModel(groupRepo: mockGroupRepository);
  MockGroupOverviewViewModel mockViewModel = MockGroupOverviewViewModel();

  setUp(() {
    reset(mockGroupRepository);
    reset(mockViewModel);
    viewModel = GroupOverviewViewModel(groupRepo: mockGroupRepository);
  });

  test('updateGroups returns empty list', () async {
    when(mockGroupRepository.getGroups()).thenAnswer((_) async => []);

    await viewModel.updateGroups();

    expect(viewModel.groups, isEmpty);
    expect(viewModel.uiState, UIState.empty);
  });

  test('updateGroups returns non-empty list', () async {
    when(mockGroupRepository.getGroups())
        .thenAnswer((_) async => [createTestGetGroupResponse()]);

    await viewModel.updateGroups();

    expect(viewModel.groups, isNotEmpty);
    expect(viewModel.uiState, UIState.normal);
  });

  test('updateGroups can set group notification count', () async {
    when(mockGroupRepository.getGroups())
        .thenAnswer((_) async => [createTestGetGroupResponse()]);

    when(mockGroupRepository.getGroupInvites()).thenAnswer(
      (_) async => [
        GetGroupInvitesResponse(
          BasicGroup(0, '', User(0, '', '', '', '', '')),
          User(0, '', '', '', '', ''),
        )
      ],
    );

    await viewModel.updateGroups();

    expect(Globals.groupNotificationsCount, 1);
    Globals.groupNotificationsCount = 0;
  });

  test('updateGroups throws exception', () async {
    when(mockGroupRepository.getGroups()).thenThrow(Exception());

    try {
      await viewModel.updateGroups();
    } catch (e) {
      expect(viewModel.uiState, UIState.error);
    }
  });

  group('UI', () {
    testWidgets('Groups should appear', (tester) async {
      final user =
          User(1, 'test@example.com', 'testuser', 'Test', 'User', 'admin');
      final getGroupResponse = GetGroupResponse(1, 'Test Group', user, 1, user);
      viewModel.groups = [getGroupResponse];

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: GroupOverViewContent(
          viewModel: viewModel,
          setParent: () {},
          onRefresh: () {
            return Future.delayed(const Duration(microseconds: 1));
          },
        ),
      )));

      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('UiStateSwitcher should work', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: GroupOverviewViewModel(
          groupRepo: mockGroupRepository,
        ),
      ));

      when(mockGroupRepository.getGroups()).thenAnswer((_) async => []);

      await tester.pumpAndSettle();

      expect(find.byType(UIStateSwitcher), findsOneWidget);

      expect(find.byType(EmptyView), findsOneWidget);
    });
  });
}

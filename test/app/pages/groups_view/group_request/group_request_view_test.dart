import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_request/group_request_view.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/models/basic_group.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/responses/get_group_invites.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/group/group_repository.dart';
import 'package:flexivity/presentation/groups_view_model/group_request_view_model/group_request_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'group_request_view_test.mocks.dart';

GetGroupInvitesResponse testReponse = GetGroupInvitesResponse(
    BasicGroup(
      1,
      "Test",
      User(1, "email@test.com", "userName1", "first", "last", "ADMIN"),
    ),
    User(1, "email@test.com", "userName1", "first", "last", "ADMIN"));

@GenerateNiceMocks([MockSpec<GroupRepository>()])
void main() {
  group('Group Detail', () {
    late MockGroupRepository mockGroupRepo;

    setUp(() {
      mockGroupRepo = MockGroupRepository();
    });

    group('viewModel', () {
      test(
        'viewModel.getGroupInvites should work when no errors are thrown',
        () async {
          when(mockGroupRepo.getGroupInvites())
              .thenAnswer((_) async => [testReponse]);

          var testViewModel = GroupRequestViewModel(groupRepo: mockGroupRepo);

          await testViewModel.getGroupInvites();

          expect(testViewModel.uiState, UIState.normal);
        },
      );

      test(
        'viewModel.getGroupInvites should work when no errors are thrown',
        () async {
          when(mockGroupRepo.getGroupInvites()).thenAnswer((_) async => []);

          var testViewModel = GroupRequestViewModel(groupRepo: mockGroupRepo);

          await testViewModel.getGroupInvites();

          expect(testViewModel.uiState, UIState.empty);
        },
      );

      test(
        'viewModel.getGroupInvites should work when no errors are thrown',
        () async {
          when(mockGroupRepo.getGroupInvites()).thenThrow(ApiException("Test"));

          var testViewModel = GroupRequestViewModel(groupRepo: mockGroupRepo);
          try {
            await testViewModel.getGroupInvites();
          } catch (e) {
            expect(e, isA<ApiException>());
            expect(testViewModel.uiState, UIState.error);
          }
        },
      );

      test('Decline invite should work when no errors are thrown', () async {
        when(mockGroupRepo.updateInvite(any)).thenAnswer((_) async => false);
        var testViewModel = GroupRequestViewModel(groupRepo: mockGroupRepo);
        testViewModel.invites = [testReponse];

        expect(testViewModel.updateGroupInvite(true, 1), throwsA(isA<ApiException>()));
      });

      test('Decline invite should work when no errors are thrown', () async {
        when(mockGroupRepo.updateInvite(any)).thenThrow(ApiException("Test"));
        var testViewModel = GroupRequestViewModel(groupRepo: mockGroupRepo);
        testViewModel.invites = [testReponse];

        expect(testViewModel.updateGroupInvite(true, 1), throwsA(isA<ApiException>()));
      });
    });

    group('UI', () {
      testWidgets(
        'UiStateSwitcher should work when no errors are thrown but the list is empty',
        (tester) async {
          var testViewModel = GroupRequestViewModel(groupRepo: mockGroupRepo);
          when(mockGroupRepo.getGroupInvites()).thenAnswer((_) async => []);

          await tester.pumpWidget(MaterialApp(
            home: testViewModel,
          ));

          await tester.pump();

          expect(find.byType(UIStateSwitcher), findsOneWidget);
          expect(testViewModel.uiState, UIState.empty);
        },
      );

      testWidgets(
        'UiStateSwitcher should work when no errors are thrown but the list is empty',
        (tester) async {
          var testViewModel = GroupRequestViewModel(groupRepo: mockGroupRepo);
          when(mockGroupRepo.getGroupInvites())
              .thenAnswer((_) async => [testReponse]);

          await tester.pumpWidget(MaterialApp(
            home: testViewModel,
          ));

          await tester.pump();

          expect(find.byType(UIStateSwitcher), findsOneWidget);
          expect(testViewModel.uiState, UIState.normal);
        },
      );

      testWidgets(
        'Accept invite should work when no errors are thrown',
        (tester) async {
          when(mockGroupRepo.updateInvite(any)).thenAnswer((_) async => true);
          var testViewModel = GroupRequestViewModel(groupRepo: mockGroupRepo);
          testViewModel.invites = [testReponse];
          testViewModel.uiState = UIState.normal;

          await tester.pumpWidget(MaterialApp(
              home: Scaffold(
            body: GroupRequestContent(
              viewModel: testViewModel,
            ),
          )));
          var button = find.byIcon(Icons.check);

          await tester.tap(button);
          await tester.pumpAndSettle();

          verify(mockGroupRepo.updateInvite(any)).called(1);
        },
      );

      testWidgets(
        'Decline invite should work when no errors are thrown',
        (tester) async {
          when(mockGroupRepo.updateInvite(any)).thenAnswer((_) async => true);
          var testViewModel = GroupRequestViewModel(groupRepo: mockGroupRepo);
          testViewModel.invites = [testReponse];
          testViewModel.uiState = UIState.normal;

          await tester.pumpWidget(MaterialApp(
              home: Scaffold(
            body: GroupRequestContent(
              viewModel: testViewModel,
            ),
          )));
          var button = find.byIcon(Icons.close);

          await tester.tap(button);
          await tester.pumpAndSettle();

          verify(mockGroupRepo.updateInvite(any)).called(1);
        },
      );
    });
  });
}

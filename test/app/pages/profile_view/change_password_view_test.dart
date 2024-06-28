import 'dart:io';

import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/profile_view/change_password_view.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/repositories/user/user_repository.dart';
import 'package:flexivity/presentation/profile_view_model/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserRepository>(),
  MockSpec<ChangePasswordViewModel>(),
])
void main() {
  MockUserRepository mockPasswordRepository = MockUserRepository();
  ChangePasswordViewModel viewModel = ChangePasswordViewModel(
    userRepo: mockPasswordRepository,
  );
  ChangePasswordViewModel mockedViewModel = MockChangePasswordViewModel();

  late Widget app;

  setUp(() {
    mockPasswordRepository = MockUserRepository();
    viewModel = ChangePasswordViewModel(
      userRepo: mockPasswordRepository,
    );
    app = MaterialApp(
      home: Scaffold(
          body: ChangePasswordStepTwoContent(viewModel: mockedViewModel)),
    );
  });
  group('UI', () {
    testWidgets(
      'Password fields in second Visibility widget validate input',
      (WidgetTester tester) async {
        ChangePasswordViewModel(
          userRepo: MockUserRepository(),
        );

        await tester.pumpWidget(MaterialApp(
          home: ChangePasswordViewModel(
            userRepo: MockUserRepository(),
          ),
        ));

// Set showFirstInput to false to make the second Visibility widget visible

        var passwordInput = find.widgetWithText(TextFormField, 'Password');

// Verify that the password fields exist
        expect(passwordInput, findsOneWidget);

// List of invalid passwords and a description of what's wrong with them
        var invalidPasswords = {
          '': 'Please enter your password',
          'password': '✘ 1 capitalized letter',
          'Password': '✘ 1 number',
          'PASSWORD': '✘ 1 lowercase letter',
          'Password1': '✘ 1 special character (@!%*?&)',
          'word1!': '✘ At least 8 characters',
        };

        for (var password in invalidPasswords.keys) {
// Enter the invalid password
          await tester.enterText(passwordInput, password);

          var sendButton = find.widgetWithText(FullWidthButton, "Send");
          await tester.ensureVisible(sendButton);
          await tester.tap(sendButton);
          await tester.pump(); // Use pump instead of pumpAndSettle

          expect(
            find.byWidgetPredicate(
              (Widget widget) =>
                  widget is Text &&
                  widget.data!.contains(invalidPasswords[password]!),
              description: 'Text containing "${invalidPasswords[password]}"',
            ),
            findsWidgets,
          );
        }
      },
    );
    testWidgets('addFriend should work when form is valid',
            (WidgetTester tester) async {
          when(mockedViewModel.changePassword()).thenAnswer((_) async => null);
          when(mockedViewModel.oldPasswordInputController)
              .thenReturn(TextEditingController(text: 'Kaas1234'));
          when(mockedViewModel.passwordInputController)
              .thenReturn(TextEditingController(text: 'Kaas1234%'));
          when(mockedViewModel.confirmPasswordInputController)
              .thenReturn(TextEditingController(text: 'Kaas1234%'));
          await tester.pumpWidget(app);
          // Find the send request button and tap it
          var sendButton = find.byType(FullWidthButton);
          await tester.tap(sendButton);
          // Rebuild the widget after the state has changed
          await tester.pump();
          expect(viewModel.uiState, UIState.normal);
          // Check if the Snackbar with the success message is shown
          expect(find.text('Request sent successfully!'), findsOneWidget);
  });
  });
  test('isPassword vissible ', () {
    expect(viewModel.hideOldPassword, true);
    expect(viewModel.hidePassword, true);
    expect(viewModel.hideConfirmPassword, true);
    viewModel.changeVisibilityOldPasswordField();
    viewModel.changeVisibilityPasswordField();
    viewModel.changeVisibilityConfirmPassword();
    expect(viewModel.hideOldPassword, false);
    expect(viewModel.hidePassword, false);
    expect(viewModel.hideConfirmPassword, false);
  });
  test('reset() should show snackbar when form is invalid', () async {
    when(mockPasswordRepository.changePassword(any, any))
        .thenAnswer((_) async => false);
    viewModel.passwordInputController.text = "";
    viewModel.confirmPasswordInputController.text = "";

    var result = viewModel.changePassword();

    expectLater(result, throwsA(isA<ApiException>()));
  });
  test('reset() should show snackbar when form is invalid', () async {
    when(mockPasswordRepository.changePassword(any, any))
        .thenAnswer((_) async => false);
    viewModel.passwordInputController.text = "";
    viewModel.confirmPasswordInputController.text = "";

    var result = viewModel.changePassword();

    expectLater(result, throwsA(isA<ApiException>()));
  });
  test('reset() should show snackbar when form is invalid', () async {
    when(mockPasswordRepository.changePassword(any, any))
        .thenAnswer((_) async => false);
    viewModel.passwordInputController.text = "Kaas1234";
    viewModel.confirmPasswordInputController.text = "Kaas1235";

    var result = viewModel.changePassword();

    expectLater(result, throwsA(isA<ApiException>()));
  });
  test('reset() should show snackbar when form is invalid', () async {
    when(mockPasswordRepository.changePassword(any, any))
        .thenAnswer((_) async => false);
    viewModel.oldPasswordInputController.text = "Kaas1234";
    viewModel.passwordInputController.text = "Kaas1234";

    var result = viewModel.changePassword();

    expectLater(result, throwsA(isA<ApiException>()));
  });
  test('reset() should show snackbar when form is invalid', () async {
    when(mockPasswordRepository.changePassword(any, any))
        .thenAnswer((_) async => false);
    viewModel.oldPasswordInputController.text = "Kaas1235";
    viewModel.passwordInputController.text = "Kaas1234";
    viewModel.confirmPasswordInputController.text = "Kaas1234";

    var result = viewModel.changePassword();

    expectLater(result, throwsA(isA<ApiException>()));
  });
  test('reset() should show snackbar when form is invalid', () async {
    when(mockPasswordRepository.changePassword(any, any))
        .thenThrow(const SocketException('failed'));
    viewModel.oldPasswordInputController.text = "Kaas1235";
    viewModel.passwordInputController.text = "Kaas1234";
    viewModel.confirmPasswordInputController.text = "Kaas1234";

    var result = viewModel.changePassword();

    expect(viewModel.uiState, UIState.normal);
    expectLater(result, throwsA(isA<ApiException>()));
  });
  test('reset() should show snackbar when form is invalid', () async {
    when(mockPasswordRepository.changePassword(any, any))
        .thenAnswer((_) async => true);
    viewModel.oldPasswordInputController.text = "Kaas1235";
    viewModel.passwordInputController.text = "Kaas1234";
    viewModel.confirmPasswordInputController.text = "Kaas1234";

    var result = viewModel.changePassword();

    expect(viewModel.uiState, UIState.normal);
    expectLater(result, completes);
  });
}

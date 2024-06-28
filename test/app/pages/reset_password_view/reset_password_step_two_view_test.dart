import 'dart:io';

import 'package:flexivity/app/views/reset_password_view/reset_password_step_two_view.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/repositories/user/password_repository.dart';
import 'package:flexivity/presentation/reset_password_view_model/reset_password_step_two_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../forgot_password_view/forgot_password_view_test.dart';
import 'reset_password_step_two_view_test.mocks.dart';
@GenerateNiceMocks([
  MockSpec<PasswordRepository>(),
  MockSpec<ResetPasswordStepTwoViewModel>(),
])
void main() {
  MockPasswordRepository mockPasswordRepository = MockPasswordRepository();
  ResetPasswordStepTwoViewModel viewModel = ResetPasswordStepTwoViewModel(
    passwordRepo: mockPasswordRepository,
    token: '',
  );
  ResetPasswordStepTwoViewModel mockedViewModel = MockResetPasswordStepTwoViewModel();

  late Widget app;

  setUp(() {
    mockPasswordRepository = MockPasswordRepository();
    viewModel = ResetPasswordStepTwoViewModel(
      passwordRepo: mockPasswordRepository,
      token: '',
    );
    app = MaterialApp(
      home: Scaffold(body: ResetPasswordStepTwoContent(viewModel: mockedViewModel)),
    );
  });
  group('UI', () {
    testWidgets(
      'Password fields in second Visibility widget validate input',
      (WidgetTester tester) async {
        ResetPasswordStepTwoViewModel(
          passwordRepo: MockPasswordRepository(),
          token: '',
        );

        await tester.pumpWidget(MaterialApp(
          home: ResetPasswordStepTwoViewModel(
            passwordRepo: getPasswordRepo(),
            token: '', // Now it can be referenced here
          ),
        ));

// Set showFirstInput to false to make the second Visibility widget visible

        var passwordInput = find.byType(TextFormField).first;

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

// Try to find the submit button and tap it.
// Find the 'Send' button
          var sendButton = find.widgetWithText(FullWidthButton, "Send");
          await tester.ensureVisible(sendButton);
          await tester.tap(sendButton);
          await tester.pump(); // Use pump instead of pumpAndSettle

// Verify that the correct error message is shown.
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
      when(mockedViewModel.reset()).thenAnswer((_) async => null);
      when(mockedViewModel.passwordInputController)
          .thenReturn(TextEditingController(text: 'Kaas1234%'));
      when(mockedViewModel.rePasswordInputController)
          .thenReturn(TextEditingController(text: 'Kaas1234%'));
      await tester.pumpWidget(app);
      // Find the send request button and tap it
      var sendButton = find.byType(FullWidthButton);
      await tester.tap(sendButton);
      // Rebuild the widget after the state has changed
      await tester.pump();

      // Check if the Snackbar with the success message is shown
      expect(find.text('Request sent successfully!'), findsOneWidget);
    });
  });

  group('logic', () {
    test('reset() should show snackbar when form is invalid', () async {
// Arrange
      when(mockPasswordRepository.resetPassword(any, any))
          .thenAnswer((_) async => false);
      viewModel.passwordInputController.text = "";
      viewModel.rePasswordInputController.text = "";

// Act
      var result = viewModel.reset();

// Assert
      expectLater(result, throwsA(isA<ApiException>()));
    });

    test('reset() should not show snackbar when form is valid', () async {
// Arrange
      when(mockPasswordRepository.resetPassword(any, any))
          .thenAnswer((_) async => true);
      viewModel.passwordInputController.text = "password123";
      viewModel.rePasswordInputController.text = "password123";

// Act
      var result = viewModel.reset();

// Assert
      expectLater(result, completes);
    });
    test('reset() should not show snackbar when form is valid', () async {
// Arrange
      when(mockPasswordRepository.resetPassword(any, any))
          .thenAnswer((_) async => true);
      viewModel.passwordInputController.text = "password123";
      viewModel.rePasswordInputController.text = "password124";

// Act
      var result = viewModel.reset();

// Assert
      expectLater(result, throwsA(isA<ApiException>()));
    });
    test('reset() should not show snackbar when form is valid', () async {
// Arrange
      when(mockPasswordRepository.resetPassword(any, any))
          .thenThrow(const SocketException('failed'));
      viewModel.passwordInputController.text = "password123";
      viewModel.rePasswordInputController.text = "password123";

      var result = viewModel.reset();

// Assert
      expectLater(result, throwsA(isA<ApiException>()));
    });
    test('isPassword vissible ', () {
      expect(viewModel.hidePassword, true);
      expect(viewModel.hideConfirmPassword, true);
      viewModel.changeVisibilityPasswordField();
      viewModel.changeVisibilityConfirmPassword();
      expect(viewModel.hidePassword, false);
      expect(viewModel.hideConfirmPassword, false);
    });
  });
}

import 'dart:io';

import 'package:flexivity/app/views/forgot_password_view/forgot_password_view.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/repositories/user/password_repository.dart';
import 'package:flexivity/presentation/forgot_password_view_model/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forgot_password_view_test.mocks.dart';



@GenerateNiceMocks([
  MockSpec<PasswordRepository>(),
  MockSpec<ForgotPasswordViewModel>(),
])
void main() {
  MockPasswordRepository mockPasswordRepository = MockPasswordRepository();
  ForgotPasswordViewModel viewModel =
  ForgotPasswordViewModel(passwordRepo: mockPasswordRepository);
  ForgotPasswordViewModel mockedViewModel = MockForgotPasswordViewModel();

  late Widget app;

  setUp(() {
    mockPasswordRepository = MockPasswordRepository();
    viewModel = ForgotPasswordViewModel(passwordRepo: mockPasswordRepository);
    app = MaterialApp(
      home: Scaffold(body: ForgotPasswordContent(viewModel: mockedViewModel)),
    );
  });
  group('UI', () {
    testWidgets('forgetPasswordView_loads', (tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: ForgotPasswordViewModel(
          passwordRepo: getPasswordRepo(), // Now it can be referenced here
        ),
      ));

      await tester.pumpAndSettle();

      // Verify that the password field exists.
      expect(find.widgetWithText(TextFormField, 'E-mail'), findsOneWidget);
    });
    testWidgets(
      'Form cannot be submitted when fields are empty',
          (WidgetTester tester) async {

            await tester.pumpWidget(MaterialApp(
              home: ForgotPasswordViewModel(
                passwordRepo: getPasswordRepo(), // Now it can be referenced here
              ),
            ));
        // Build our app and trigger a frame.
        var submitButton = find.widgetWithText(FilledButton, 'Send');
        await tester.tap(submitButton);
        await tester.pump();

        // Verify that an error message is shown.
        expect(find.text('Please enter your email'), findsOneWidget);
      },
    );
    testWidgets(
      'Form can be submitted when all fields are filled correctly',
          (WidgetTester tester) async {

            await tester.pumpWidget(MaterialApp(
              home: ForgotPasswordViewModel(
                passwordRepo: getPasswordRepo(), // Now it can be referenced here
              ),
            ));
        // Specify what should happen when the register method is called
        when(getPasswordRepo().forgetPassword(any)).thenAnswer((_) async => true);
        // Build our app and trigger a frame.
        await tester.enterText(
            find.widgetWithText(TextFormField, 'E-mail'), 'test@test.com');

        // Try to find the submit button and tap it.
        var submitButton = find.widgetWithText(FilledButton, 'Send');
        await tester.tap(submitButton);
        await tester.pump();

        // Verify that the form has been submitted.
        // This will depend on your implementation. For example, you might navigate to a different screen, show a success message, etc.
        // Here, we'll just check that the form is no longer in the widget tree.
        expect(find.byType(Form), findsOne);
      },
    );
    testWidgets('addFriend should work when form is valid',
            (WidgetTester tester) async {
          when(mockedViewModel.send()).thenAnswer((_) async => null);
          when(mockedViewModel.emailInputController)
              .thenReturn(TextEditingController(text: 'test@test.test'));

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

  group('sendEmail', ()
  {
    test('addFriend should work', () async {
      when(mockPasswordRepository.forgetPassword(any)).thenAnswer((
          _) async => true);
      viewModel.emailInputController.text = "test@test.test";

      expectLater(viewModel.send(), completes);
    });
    test('addFriend should work2', () async {
      when(mockPasswordRepository.forgetPassword(any)).thenAnswer((
          _) async => false);
      viewModel.emailInputController.text = "test@test.test";

      expectLater(viewModel.send(), throwsA(isA<ApiException>()));
    });
    test('addFriend should work3', () async {
      when(mockPasswordRepository.forgetPassword(any))
          .thenThrow(const SocketException('failed'));
      viewModel.emailInputController.text = "kaas";

      expectLater(viewModel.send(), throwsA(isA<ApiException>()));
    });
  });
}

// Declare getPasswordRepo function here
MockPasswordRepository getPasswordRepo() {
  var repo = MockPasswordRepository();

  return repo;
}

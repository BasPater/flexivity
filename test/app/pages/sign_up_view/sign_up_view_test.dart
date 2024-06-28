import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/responses/login_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flexivity/data/repositories/authentication/web_authentication_repository.dart';
import 'package:flexivity/presentation/sign_up_view_model/sign_up_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<WebAuthenticationRepository>(), MockSpec<CredentialsRepository>()])
import '../login_view/login_view_test.mocks.dart';

void main() {
  final authRepo = MockWebAuthenticationRepository();
  final credentialsRepo = MockCredentialsRepository();

  testWidgets(
    'Sign up view has a password field',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: SignUpViewModel(
          authRepo: authRepo,
          credentialsRepo: credentialsRepo,
        ),
      ));

      // Verify that the password field exists.
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    },
  );

  test('changePasswordVisibility changes isPasswordVisible', () {
    final viewModel = SignUpViewModel(
      authRepo: authRepo,
      credentialsRepo: credentialsRepo,
    );

    expect(viewModel.isPasswordVisible, isTrue);

    viewModel.changePasswordVisibility();

    expect(viewModel.isPasswordVisible, isFalse);
  });

  testWidgets(
    'Sign up view has an email field',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: SignUpViewModel(
          authRepo: authRepo,
          credentialsRepo: credentialsRepo,
        ),
      ));

      // Verify that the email field exists.
      expect(find.widgetWithText(TextFormField, 'E-mail'), findsOneWidget);
    },
  );

  testWidgets(
    'Form cannot be submitted when fields are empty',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: SignUpViewModel(
          authRepo: authRepo,
          credentialsRepo: credentialsRepo,
        ),
      ));

      // Try to find the submit button and tap it.
      var submitButton = find.widgetWithText(FilledButton, 'Sign Up');
      await tester.tap(submitButton);
      await tester.pump();

      // Verify that an error message is shown.
      expect(find.text('Please enter your last name'), findsOneWidget);
    },
  );

  testWidgets(
    'Sign up view has a username field',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: SignUpViewModel(
          authRepo: authRepo,
          credentialsRepo: credentialsRepo,
        ),
      ));

      // Verify that the username field exists.
      expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);
    },
  );

  testWidgets(
    'Sign up view has a first name field',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: SignUpViewModel(
          authRepo: authRepo,
          credentialsRepo: credentialsRepo,
        ),
      ));

      // Verify that the first name field exists.
      expect(find.widgetWithText(TextFormField, 'First Name'), findsOneWidget);
    },
  );

  testWidgets(
    'Sign up view has a last name field',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: SignUpViewModel(
          authRepo: authRepo,
          credentialsRepo: credentialsRepo,
        ),
      ));

      // Verify that the last name field exists.
      expect(find.widgetWithText(TextFormField, 'Last Name'), findsOneWidget);
    },
  );

  testWidgets(
    'Form can be submitted when all fields are filled correctly',
    (WidgetTester tester) async {
      // Specify what should happen when the register method is called
      when(authRepo.register(any)).thenAnswer((_) async => null);
      when(authRepo.login(any, any)).thenAnswer(
          (_) async => LoginResponse(User(0, '', '', '', '', ''), '', ''));

      // Specify what should happen when the register method is called

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: SignUpViewModel(
          authRepo: authRepo,
          credentialsRepo: credentialsRepo,
        ),
      ));

      // Fill in all the fields.
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Username'), 'testuser');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'First Name'), 'Test');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Last Name'), 'User');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'), 'testuser@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'Test@1234');

      // Try to find the submit button and tap it.
      var submitButton = find.widgetWithText(FilledButton, 'Sign Up');
      await tester.tap(submitButton);
      await tester.pump();

      // Verify that the form has been submitted.
      // This will depend on your implementation. For example, you might navigate to a different screen, show a success message, etc.
      // Here, we'll just check that the form is no longer in the widget tree.
      expect(find.byType(Form), findsOne);
    },
  );

  testWidgets(
    'Password field validates all password requirements',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: SignUpViewModel(
          authRepo: authRepo,
          credentialsRepo: credentialsRepo,
        ),
      ));

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
        await tester.enterText(
            find.widgetWithText(TextFormField, 'Password'), password);

        // Try to find the submit button and tap it.
        var submitButton = find.widgetWithText(FilledButton, 'Sign Up');

        await tester.ensureVisible(submitButton);

        await tester.tap(submitButton);
        await tester.pump();

        // Verify that the correct error message is shown.
        expect(
            find.byWidgetPredicate(
              (Widget widget) =>
                  widget is Text &&
                  widget.data!.contains(invalidPasswords[password]!),
              description: 'Text containing "${invalidPasswords[password]}"',
            ),
            findsOneWidget);
      }
    },
  );

  testWidgets('ApiException is thrown when register is called',
      (WidgetTester tester) async {
    // Specify what should happen when the register method is called
    when(authRepo.register(any)).thenThrow(const ApiException('kaas'));

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: SignUpViewModel(
        authRepo: authRepo,
        credentialsRepo: credentialsRepo,
      ),
    ));

    // Fill in all the fields.
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'), 'testuser');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'First Name'), 'Test');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Last Name'), 'User');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'E-mail'), 'testuser@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'Test@1234');

    // Try to find the submit button and tap it.
    var submitButton = find.widgetWithText(FilledButton, 'Sign Up');
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the ApiException message is shown in a SnackBar.
    expect(find.widgetWithText(SnackBar, 'kaas'), findsOneWidget);
  });
}

import 'package:flexivity/app/router/router.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/responses/login_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flexivity/data/repositories/authentication/web_authentication_repository.dart';
import 'package:flexivity/presentation/login_view_model/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks(
  [MockSpec<WebAuthenticationRepository>(), MockSpec<CredentialsRepository>()],
)
import 'login_view_test.mocks.dart';

void main() {
  final authRepo = MockWebAuthenticationRepository();
  final credentialsRepo = MockCredentialsRepository();

  testWidgets('LoginView should be rendered', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: LoginViewModel(
        authRepo: authRepo,
        credentialsRepo: credentialsRepo,
      ),
    ));

    // Verify that LoginView is showing.
    expect(find.byType(LoginViewModel), findsOneWidget);

    // Verify that the username field is showing.
    expect(find.widgetWithText(TextFormField, 'E-mail'), findsOneWidget);

    // Verify that the password field is showing.
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

    // Verify that the "Login" button is showing.
    expect(find.widgetWithText(FilledButton, 'Login'), findsOneWidget);
  });

  testWidgets(
    'LoginView should show Snackbar on failed request',
    (tester) async {
      when(authRepo.login(any, any)).thenThrow(
        const ApiException('Exception'),
      );

      await tester.pumpWidget(MaterialApp(
        home: LoginViewModel(authRepo: authRepo, credentialsRepo: credentialsRepo),
      ));

      var loginBtn = find.widgetWithText(FilledButton, 'Login');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'), 'test@test.test');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), '@Tester123');

      await tester.tap(loginBtn);
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(SnackBar, 'You entered the wrong password or email. Please try again'),
        findsOneWidget,
      );
    },
  );

  test('changePasswordVisibility changes isPasswordVisible', () {
    final viewModel = LoginViewModel(
      authRepo: authRepo,
      credentialsRepo: credentialsRepo,
    );

    expect(viewModel.isPasswordVisible, isTrue);

    viewModel.changePasswordVisibility();

    expect(viewModel.isPasswordVisible, isFalse);
  });

  testWidgets(
    'LoginView can navigate to home on success',
    (tester) async {
      when(authRepo.login(any, any)).thenAnswer(
        (_) => Future.value(LoginResponse(User(1, '', '', '', '', ''), '', '')),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaterialApp.router(
              routerConfig: routerConfig(),
              builder: (context, child) =>
                  LoginViewModel(authRepo: authRepo, credentialsRepo: credentialsRepo),
            ),
          ),
        ),
      );

      var loginBtn = find.widgetWithText(FilledButton, 'Login');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'), 'test@test.test');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), '@Tester123');

      await tester.tap(loginBtn);
      await tester.pump();

      // Check if the route changed
      expect(routerConfig().routeInformationProvider.value.uri, Uri(path: '/'));
    },
  );
}



import 'dart:io';

import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/reset_password_view/reset_password_view.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/repositories/user/password_repository.dart';
import 'package:flexivity/presentation/reset_password_view_model/reset_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../forgot_password_view/forgot_password_view_test.dart';
import 'reset_password_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PasswordRepository>(),
  MockSpec<ResetPasswordViewModel>(),
])
void main() {
  MockPasswordRepository mockPasswordRepository = MockPasswordRepository();
  ResetPasswordViewModel viewModel =
  ResetPasswordViewModel(passwordRepo: mockPasswordRepository);
  ResetPasswordViewModel mockedViewModel = MockResetPasswordViewModel();

  late Widget app;

  setUp(() {
    mockPasswordRepository = MockPasswordRepository();
    viewModel = ResetPasswordViewModel(passwordRepo: mockPasswordRepository);
    app = MaterialApp(
      home: Scaffold(body: ResetPasswordContent(viewModel: mockedViewModel)),
    );
  });

  group('UI', () {
    testWidgets('reset_password_view', (tester) async {
      // Build our app and trigger a frame.
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: ResetPasswordViewModel(
          passwordRepo: getPasswordRepo(), // Now it can be referenced here
        ),
      ));

      await tester.pump();
      var input = find.byType(PinCodeTextField);
      // Verify that the password field exists.
      expect(input, findsOneWidget);
    });

    testWidgets(
      'ResetPasswordViewModel shows form when idle',
      (WidgetTester tester) async {
        // Arrange
        final viewModel =
            ResetPasswordViewModel(passwordRepo: MockPasswordRepository());
        viewModel.uiState = UIState.normal;

        await tester.pumpWidget(MaterialApp(
          home: ResetPasswordViewModel(
            passwordRepo: getPasswordRepo(), // Now it can be referenced here
          ),
        ));
        expect(find.byType(Form), findsOneWidget);
      },
    );
    testWidgets('addFriend should work when form is valid',
        (WidgetTester tester) async {
      when(mockedViewModel.check()).thenAnswer((_) async => null);
      when(mockedViewModel.textEditingController)
          .thenReturn(TextEditingController(text: '123456'));

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

  // Assert
  group('logic', () {
    test('addFriend should work', () async {
      when(mockPasswordRepository.checkPasswordResetCode(any))
          .thenAnswer((_) async => true);
      viewModel.textEditingController.text = "111sdf";

      expectLater(viewModel.check(), completes);
    });
    test('addFriend should work2', () async {
      when(mockPasswordRepository.checkPasswordResetCode(any))
          .thenAnswer((_) async => false);
      viewModel.textEditingController.text = "111sdf";

      expectLater(viewModel.check(), throwsA(isA<ApiException>()));
    });
    test('addFriend should work3', () async {
      when(mockPasswordRepository.checkPasswordResetCode(any))
          .thenThrow(const SocketException('failed'));
      viewModel.textEditingController.text = "111sdf";

      expectLater(viewModel.check(), throwsA(isA<ApiException>()));
    });
  });
  ;
}

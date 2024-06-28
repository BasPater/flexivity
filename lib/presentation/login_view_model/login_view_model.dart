import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/login_view/login_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/responses/login_response.dart';
import 'package:flexivity/domain/repositories/authentication/abstract_authentication_repository.dart';
import 'package:flexivity/domain/repositories/credentials/abstract_credentials_repository.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginViewModel extends StatefulWidget {
  final IAuthenticationRepository authRepo;
  final ICredentialsRepository credentialsRepo;
  final TextEditingController emailInputController;
  final TextEditingController passwordInputController;
  UIState uiState = UIState.normal;

  bool isPasswordVisible = true;

  LoginViewModel({
    super.key,
    required this.authRepo,
    required this.credentialsRepo,
  })  : emailInputController = TextEditingController(),
        passwordInputController = TextEditingController();

  void changePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  /// Logs a user in based on the page form
  Future login() async {
    String email = emailInputController.value.text;
    String password = passwordInputController.value.text;

    try {
      LoginResponse response = await authRepo.login(email, password);
      await credentialsRepo.setCredentials(
        response.user.userId,
        response.accessToken,
        response.refreshToken,
      );
      
      Globals.credentials = await credentialsRepo.getCredentials();
      Globals.user = response.user;
      uiState = UIState.normal;
    } on ApiException catch (_) {
      uiState = UIState.normal;
      return Future.error(ApiException(
        "You entered the wrong password or email. Please try again",
      ));
    }
  }

  @override
  State<LoginViewModel> createState() => LoginViewModelState();
}

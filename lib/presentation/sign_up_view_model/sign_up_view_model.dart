import 'package:flexivity/app/constants/password_requirements.dart';
import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/sign_up_view/sign_up_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/new_user.dart';
import 'package:flexivity/data/models/responses/login_response.dart';
import 'package:flexivity/domain/repositories/authentication/abstract_authentication_repository.dart';
import 'package:flexivity/domain/repositories/credentials/abstract_credentials_repository.dart';
import 'package:flutter/material.dart';

const int minimumPasswordLength = 8;

// ignore: must_be_immutable
class SignUpViewModel extends StatefulWidget {
  final IAuthenticationRepository authRepo;
  final ICredentialsRepository credentialsRepo;
  final TextEditingController emailInputController;
  final TextEditingController usernameInputController;
  final TextEditingController firstNameInputController;
  final TextEditingController lastNameInputController;
  final TextEditingController passwordInputController;
  UIState uiState = UIState.normal;

  bool isPasswordVisible = true;

  SignUpViewModel({
    super.key,
    required this.authRepo,
    required this.credentialsRepo,
  })  : emailInputController = TextEditingController(),
        usernameInputController = TextEditingController(),
        firstNameInputController = TextEditingController(),
        lastNameInputController = TextEditingController(),
        passwordInputController = TextEditingController();

  void changePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  /// Registers a new user based on the page form user
  Future register() async {
    String email = emailInputController.value.text;
    String username = usernameInputController.value.text;
    String firstName = firstNameInputController.value.text;
    String lastName = lastNameInputController.value.text;
    String password = passwordInputController.value.text;

    try {
      await authRepo.register(
        NewUser(
          0,
          email,
          username,
          firstName,
          lastName,
          'USER',
          password,
        ),
      );

      LoginResponse response = await authRepo.login(email, password);
      await credentialsRepo.setCredentials(
        response.user.userId,
        response.accessToken,
        response.refreshToken,
      );

      Globals.credentials = await credentialsRepo.getCredentials();
      Globals.user = response.user;
      uiState = UIState.normal;
    } on ApiException catch (e) {
      uiState = UIState.normal;
      return Future.error(e);
    }
  }

  @override
  State<SignUpViewModel> createState() => SignUpView();

  /// Checks if the given e-mail is valid
  bool isValidEmail(String email) {
    // This regex checks whether the given email is valid
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }

  /// Check if the given password is valid
  /// Regex from https://stackoverflow.com/a/21456918
  String? isValidPassword(String password) {
    StringBuffer buffer = StringBuffer();
    bool passes = true;

    // Required to parse the format string
    List<String> requirementTexts = List.of(passwordRequirements
        .split('\n')
        .map((e) => e.trim().replaceAll('- ', '')));

    // Write description text
    buffer.writeln(requirementTexts[0]);

    // Check if the password is at least 8 characters long
    if (password.length >= minimumPasswordLength) {
      buffer.writeln('\t\t ✔ ${requirementTexts[1]}');
    } else {
      passes = false;
      buffer.writeln('\t\t ✘ ${requirementTexts[1]}');
    }

    // Check if the password contains at least 1 capitalized letter
    if (RegExp(r'[A-Z]{1}').hasMatch(password)) {
      buffer.writeln('\t\t ✔ ${requirementTexts[2]}');
    } else {
      passes = false;
      buffer.writeln('\t\t ✘ ${requirementTexts[2]}');
    }

    // Check if the password contains at least 1 lowercase letter
    if (RegExp(r'[a-z]{1}').hasMatch(password)) {
      buffer.writeln('\t\t ✔ ${requirementTexts[3]}');
    } else {
      passes = false;
      buffer.writeln('\t\t ✘ ${requirementTexts[3]}');
    }

    // Check if the password contains at least 1 number
    if (RegExp(r'[1-9]{1}').hasMatch(password)) {
      buffer.writeln('\t\t ✔ ${requirementTexts[4]}');
    } else {
      passes = false;
      buffer.writeln('\t\t ✘ ${requirementTexts[4]}');
    }

    // Check if the password contains at least one special character
    if (RegExp(r'[@!%*?&]{1}').hasMatch(password)) {
      buffer.writeln('\t\t ✔ ${requirementTexts[5]}');
    } else {
      passes = false;
      buffer.writeln('\t\t ✘ ${requirementTexts[5]}');
    }

    return passes ? null : buffer.toString();
  }
}

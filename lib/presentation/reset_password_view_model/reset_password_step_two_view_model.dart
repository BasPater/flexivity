import 'package:flexivity/app/views/reset_password_view/reset_password_step_two_view.dart';
import 'package:flutter/material.dart';

import '../../app/constants/password_requirements.dart';
import '../../app/models/ui_state.dart';
import '../../data/models/errors/api_exception.dart';
import '../../domain/repositories/user/abstract_password_repository.dart';
import '../sign_up_view_model/sign_up_view_model.dart';

//ignore: must_be_immutable
class ResetPasswordStepTwoViewModel extends StatefulWidget {
  final  passwordInputController = TextEditingController();
  final  rePasswordInputController = TextEditingController();
  final IPasswordRepository passwordRepo;
  final String token; // Declare token as a field
  UIState uiState = UIState.normal;

  ResetPasswordStepTwoViewModel(
      {super.key, required this.passwordRepo, required this.token});


  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  ResetPasswordStepTwoViewState createState() => ResetPasswordStepTwoViewState();

  void changeVisibilityPasswordField() {
    hidePassword = !hidePassword;
  }
  void changeVisibilityConfirmPassword() {
    hideConfirmPassword = !hideConfirmPassword;
  }

  Future reset() async {
    String password = passwordInputController.value.text;
    String confirmPassword = rePasswordInputController.value.text;

    if (password != confirmPassword) {
      return Future.error(ApiException("Passwords do not match"));
    }
    try {
      bool result = await passwordRepo.resetPassword(password, token);
      if (result) {
        uiState = UIState.normal;
        return null;
      }
      return Future.error(ApiException(
          'Couldn\'t send the change the password because the password or token arent valid'));
    } catch (e) {
      uiState = UIState.normal;
      return Future.error(const ApiException(
          'Something went wrong when changing the password'));
    }
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

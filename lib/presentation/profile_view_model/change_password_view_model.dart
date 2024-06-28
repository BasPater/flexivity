import 'package:flutter/material.dart';

import '../../../domain/repositories/user/abstract_user_repository.dart';
import '../../app/constants/password_requirements.dart';
import '../../app/models/ui_state.dart';
import '../../app/views/profile_view/change_password_view.dart';
import '../../data/models/errors/api_exception.dart';
import '../sign_up_view_model/sign_up_view_model.dart';

// ignore: must_be_immutable
class ChangePasswordViewModel extends StatefulWidget {
  final oldPasswordInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();
  final IUserRepository userRepo;
  UIState uiState = UIState.normal;

  ChangePasswordViewModel(
      {super.key, required this.userRepo});

  bool hideOldPassword = true;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  State<ChangePasswordViewModel> createState() => ChangePasswordViewState();

  void changeVisibilityOldPasswordField() {
    hideOldPassword = !hideOldPassword;
  }

  void changeVisibilityPasswordField() {
    hidePassword = !hidePassword;
  }

  void changeVisibilityConfirmPassword() {
    hideConfirmPassword = !hideConfirmPassword;
  }

  Future changePassword() async {
    String oldPassword = oldPasswordInputController.value.text;
    String password = passwordInputController.value.text;
    String confirmPassword = confirmPasswordInputController.value.text;

    if (password != confirmPassword) {
      return Future.error(ApiException("new Passwords do not match"));
    }
    if (oldPassword == password) {
      return Future.error(ApiException("old password can't be new password"));
    }
    try {
      bool result = await userRepo.changePassword(oldPassword, password);

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


import 'package:flexivity/domain/repositories/user/abstract_password_repository.dart';
import 'package:flexivity/app/views/forgot_password_view/forgot_password_view.dart';
import 'package:flutter/material.dart';

import '../../app/models/ui_state.dart';
import '../../data/models/errors/api_exception.dart';

// ignore: must_be_immutable
class ForgotPasswordViewModel extends StatefulWidget {
  final  emailInputController = TextEditingController();
  final IPasswordRepository passwordRepo;
  UIState uiState = UIState.normal;

  ForgotPasswordViewModel({super.key, required this.passwordRepo});

  Future send() async {
    try {
      var email = emailInputController.text;
      bool result = await passwordRepo.forgetPassword(email);
      uiState = UIState.normal;
      if (result) {
        return null;
      }
      return Future.error(ApiException(
          'Couldn\'t send the friend request because "${email}" isn\'t a valid email.'));
    } catch (e) {
      uiState = UIState.normal;
      return Future.error(ApiException(
          'Something went wrong when sending email error'));
    }
  }

  @override
  State<StatefulWidget> createState() => ForgotPasswordViewModelState();
}

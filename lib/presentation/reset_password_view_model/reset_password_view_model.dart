
import 'package:flexivity/app/views/reset_password_view/reset_password_view.dart';
import 'package:flutter/material.dart';

import '../../app/models/ui_state.dart';
import '../../data/models/errors/api_exception.dart';
import '../../domain/repositories/user/abstract_password_repository.dart';

//ignore: must_be_immutable
class ResetPasswordViewModel extends StatefulWidget {
  final IPasswordRepository passwordRepo;
  final textEditingController =  TextEditingController();
  UIState uiState = UIState.normal;

  ResetPasswordViewModel({super.key, required this.passwordRepo});


  Future check() async {
    final code = textEditingController.text;
    try {
      bool result = await passwordRepo.checkPasswordResetCode(code);
      uiState = UIState.normal;
      if (result) {
        return null;
      }
      return Future.error(ApiException(
          'Couldn\'t send the change the password because the code is invalid'));
    } catch (e) {
      uiState = UIState.normal;
      return Future.error(const ApiException(
          'Something went wrong when checking the code'));
    }
  }
  @override
  State<ResetPasswordViewModel> createState() => ResetPasswordViewModelState();
}

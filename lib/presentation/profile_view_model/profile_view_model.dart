import 'dart:async';

import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/profile_view/profile_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/responses/get_user_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/domain/repositories/credentials/abstract_credentials_repository.dart';
import 'package:flexivity/domain/repositories/preferences/abstract_preferences_repository.dart';
import 'package:flexivity/domain/repositories/user/abstract_user_repository.dart';
import 'package:flexivity/presentation/helper/credentials_helper.dart'
    as credHelper;
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfileScreenViewModel extends StatefulWidget {
  final ICredentialsRepository credentialsRepo;
  final IPreferencesRepository prefRepo;
  final IUserRepository userRepo;
  final stepGoalController = TextEditingController();
  final deleteAccountController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  UIState uiState = UIState.loading;
  User? user;

  ProfileScreenViewModel({
    super.key,
    required this.prefRepo,
    required this.userRepo,
    required this.credentialsRepo,
  });

  Future<void> getStepGoal() async {
    final steps = await prefRepo.getStepGoal();
    stepGoalController.text = steps ?? "";
  }

  setStepGoal() {
    prefRepo.setStepGoal(stepGoalController.text);
  }

  Future<void> getUser() async {
    if (Globals.user == null) {
      this.uiState = UIState.error;
    } else {
      this.uiState = UIState.normal;
      this.user = Globals.user;
    }
  }

  Future deleteUser() async {
    try {
      deleteAccountController.text = "";
      if (user?.userId != null) {
        userRepo.deleteUser(user?.userId ?? 0);
        logout();
      } else {
        throw Exception('UserId is null');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future logout() async => credHelper.logOut(this.credentialsRepo);

  Future updateUser() async {
    try {
      if (user?.userId != null) {
        User updatedUser = User(
          user?.userId ?? 0,
          user?.email ?? "",
          user?.userName ?? "",
          firstNameController.text,
          lastNameController.text,
          user?.role ?? "USER",
        );
        GetUserResponse response = await userRepo.updateUser(updatedUser);
        this.user = response.user;
        Globals.user = response.user;
        firstNameController.text = user?.firstName ?? "";
        lastNameController.text = user?.lastName ?? "";
        uiState = UIState.normal;
      } else {
        throw Exception('UserId is null');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  State<ProfileScreenViewModel> createState() => ProfileScreenState();
}

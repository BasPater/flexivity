import 'dart:async';

import 'package:flexivity/data/remote/user/password_api.dart';

import '../../../domain/repositories/user/abstract_password_repository.dart';

class PasswordRepository implements IPasswordRepository {
  final PasswordApi api;

  PasswordRepository(this.api);

  @override
  Future<bool> forgetPassword(String email) {
    return api.forgetPassword(email);
  }

  @override
  Future<bool> checkPasswordResetCode(String code) {
    return api.checkPasswordResetCode(code);
  }

  @override
  Future<bool> resetPassword(String password, String code) {
    return api.resetPassword(password, code);
  }

}

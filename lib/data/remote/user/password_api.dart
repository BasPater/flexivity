import 'dart:io';

import 'package:flexivity/data/remote/user/abstract_password_api.dart';
import 'package:http/http.dart';

import '../base/http_api.dart';

class PasswordApi extends HttpApi implements IPasswordApi {
  PasswordApi(Client client) : super(client, null);

  @override
  Future<bool> forgetPassword(String email) async {
      Response response = await super.post(
        'api/v1/user/forgot-password',
        body: {
          'email': email,
        },
      );
      // Check if the request succeeded
      return response.statusCode == HttpStatus.ok;
  }

  @override
  Future<bool> checkPasswordResetCode(String code) async {
      Response response = await super.post(
        'api/v1/user/check-token',
        body: {
          'token': code,
        },
      );
      // Check if the request succeeded
      return response.statusCode == HttpStatus.ok;
  }

  @override
  Future<bool> resetPassword(String password, String code) async {
      Response response = await super.post(
        'api/v1/user/reset-password',
          body: {
            'password': password,
            'token': code,
          },
      );
      // Check if the request succeeded
      return response.statusCode == HttpStatus.ok;
  }
}

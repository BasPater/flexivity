import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/responses/get_user_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/remote/base/http_api.dart';
import 'package:flexivity/data/remote/user/abstract_user_api.dart';
import 'package:http/http.dart';

class UserApi extends HttpApi implements IUserApi {
  UserApi(super.client, super.credentials);

  @override
  Future<GetUserResponse> getUser(int id) async {
    Response response = await super.get(
      'api/v1/user/$id',
    );
    // Check if the request succeeded
    if (response.statusCode != HttpStatus.ok) {
      return Future.error(ApiException(
        'Error retrieving user, status: ${response.statusCode}.',
      ));
    }
    return GetUserResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Future<GetUserResponse> updateUser(User user) async {
    Response response = await super.patch(
      'api/v1/user',
      body: {
        'userId': user.userId,
        'firstname': user.firstName,
        'lastname': user.lastName,
      },
    );
    // Check if the request succeeded
    if (response.statusCode != HttpStatus.ok) {
      return Future.error(ApiException(
        'Error deleting user, status: ${response.statusCode}.',
      ));
    }
    return GetUserResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Future deleteUser(int id) async {
    Response response = await super.delete(
      'api/v1/user',
      body: {
        'userId': id,
      },
    );
    // Check if the request succeeded
    if (response.statusCode != HttpStatus.ok) {
     throw super.createHttpException(response, "Failed to delete user.");
    }
    return true;
  }

  @override
  Future changePassword(String currentPassword, String newPassword) async {
    Response response = await super.put(
      'api/v1/user/change-password',
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
    // Check if the request succeeded
    if (response.statusCode != HttpStatus.ok) {
      return Future.error(ApiException(
        'Error deleting user, status: ${response.statusCode}.',
      ));
    }
    return true;
  }
}

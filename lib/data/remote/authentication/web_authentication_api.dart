import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/models/new_user.dart';
import 'package:flexivity/data/models/requests/login_request.dart';
import 'package:flexivity/data/models/responses/login_response.dart';
import 'package:flexivity/data/remote/authentication/abstract_authentication_api.dart';
import 'package:flexivity/data/remote/base/http_api.dart';
import 'package:http/http.dart';

class WebAuthenticationApi extends HttpApi implements IAuthenticationApi {
  WebAuthenticationApi(Client client) : super(client, null);

  /// Sends a register request to the back-end
  @override
  Future register(NewUser user) async {
    Response response = await super.post(
      'api/v1/auth/register',
      body: user,
    );

    // Check if the request succeeded
    if (response.statusCode != HttpStatus.ok) {
      return Future.error(
        super.createHttpException(
          response,
          'Error registering user, status: ${response.statusCode}.',
        ),
      );
    }
  }

  /// Sends a login request to the back-end
  @override
  Future<LoginResponse> login(String email, String password) async {
    Response response = await super.post(
      'api/v1/auth/authenticate',
      body: LoginRequest(email, password),
    );

    // Check if the request succeeded
    if (response.statusCode != HttpStatus.ok) {
      return Future.error(
        super.createHttpException(response, 'Error logging in user.'),
      );
    }

    return LoginResponse.fromJson(jsonDecode(response.body));
  }
}

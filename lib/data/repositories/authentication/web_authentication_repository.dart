import 'package:flexivity/data/models/new_user.dart';
import 'package:flexivity/data/models/responses/login_response.dart';
import 'package:flexivity/data/remote/authentication/web_authentication_api.dart';
import 'package:flexivity/domain/repositories/authentication/abstract_authentication_repository.dart';
import 'package:http/http.dart';

class WebAuthenticationRepository implements IAuthenticationRepository {
  final WebAuthenticationApi api;

  WebAuthenticationRepository({WebAuthenticationApi? api})
      : api = api ?? WebAuthenticationApi(Client());

  /// Sends a request to the API to register a new user
  @override
  Future register(NewUser user) async {
    return api.register(user);
  }

  /// Sends a request to the API to login the given user
  @override
  Future<LoginResponse> login(String email, String password) async {
    return api.login(email, password);
  }
}

import 'package:flexivity/data/models/new_user.dart';
import 'package:flexivity/data/models/responses/login_response.dart';


abstract interface class IAuthenticationRepository {
  Future register(NewUser user);
  Future<LoginResponse> login(String email, String password);
}

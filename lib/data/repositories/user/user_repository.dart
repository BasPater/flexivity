import 'package:flexivity/data/models/responses/get_user_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/remote/user/user_api.dart';
import 'package:flexivity/domain/repositories/user/abstract_user_repository.dart';

class UserRepository implements IUserRepository {
  final UserApi api;

  UserRepository(this.api);

  @override
  Future<GetUserResponse> getUser(int id) {
    return api.getUser(id);
  }

  @override
  Future<GetUserResponse> updateUser(User user) {
    return api.updateUser(user);
  }

  @override
  Future deleteUser(int id) async {
    return api.deleteUser(id);
  }

  @override
  Future changePassword(String currentPassword, String newPassword) {
    return api.changePassword(currentPassword, newPassword);
  }

}

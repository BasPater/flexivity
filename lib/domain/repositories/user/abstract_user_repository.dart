import 'package:flexivity/data/models/responses/get_user_response.dart';
import 'package:flexivity/data/models/user.dart';

abstract interface class IUserRepository {
  Future<GetUserResponse> updateUser(User user);
  Future<GetUserResponse> getUser(int id);
  Future deleteUser(int id);
  Future changePassword(String currentPassword, String newPassword);
}
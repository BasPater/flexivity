import 'package:flexivity/data/models/user.dart';

class GetUserResponse {
  final User user;

  const GetUserResponse(this.user);

  GetUserResponse.fromJson(Map<String, dynamic> json)
      : user = User.fromJson(json);

}

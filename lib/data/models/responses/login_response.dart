import 'package:flexivity/data/models/user.dart';

class LoginResponse {
  final User user;
  final String accessToken;
  final String refreshToken;

  const LoginResponse(this.user, this.accessToken, this.refreshToken);

  LoginResponse.fromJson(Map<String, dynamic> json)
      : user = User.fromJson(json['user']),
        accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];

  Map<String, dynamic> toJson() => {
        'user': user,
        'accessToken': accessToken,
        'refreshToken': accessToken,
      };
}

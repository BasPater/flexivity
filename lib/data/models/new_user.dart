import 'package:flexivity/data/models/user.dart';

class NewUser extends User {
  String password;
  NewUser(
    super.userId,
    super.email,
    super.userName,
    super.firstName,
    super.lastName,
    super.role,
    this.password,
  );

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'password': password
  };
}

import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/user.dart';

abstract class Globals {
  static Credentials? credentials;
  static User? user;
  static int friendNotificationsCount = 0;
  static int groupNotificationsCount = 0;
}

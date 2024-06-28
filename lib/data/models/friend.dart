import 'package:flexivity/data/models/day_activity.dart';
import 'package:flexivity/data/models/user.dart';

class Friend extends User {
  final DayActivity? activity;

  Friend(
    super.userId,
    super.email,
    super.userName,
    super.firstName,
    super.lastName,
    super.role,
    this.activity,
  );

  @override
  Map<String, dynamic> toJson() => {
        'user': super.toJson(),
        'activity': activity?.toJson(),
      };

  Friend.fromJson(Map<String, dynamic> json)
      : activity = json['activity'] != null
            ? DayActivity.fromJson(json['activity'])
            : null,
        super.fromJson(json['user']);
}

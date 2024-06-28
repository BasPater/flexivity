import 'package:flexivity/data/models/user.dart';

class Member{
  final User user;
  final BasicActivity activity;

  Member(this.user, this.activity);

  factory Member.fromJson(Map<String, dynamic> json){
    return Member(
      User.fromJson(json['user']),
      BasicActivity.fromJson(json['activity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'activity': activity.toJson(),
    };
  }
}

class BasicActivity{
  final int steps;
  final double calories;

  BasicActivity(this.steps, this.calories);

  factory BasicActivity.fromJson(Map<String, dynamic> json){
    return BasicActivity(
      json['steps'],
      json['calories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'calories': calories,
    };
  }
}
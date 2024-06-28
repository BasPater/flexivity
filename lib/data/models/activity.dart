
class Activity {
  final int activityId;
  final DateTime activityAt;
  final int steps;
  final double calories;

  const Activity(this.activityId, this.steps, this.calories, this.activityAt);

  Activity.fromJson(Map<String, dynamic> json)
      : activityId = json['activityId'] as int,
        activityAt = DateTime.parse(json['activityAt'] as String),
        steps = json['steps'] as int,
        calories = json['calories'] as double;

  Map<String, dynamic> toJson() => {
    'activityId': activityId,
    'activityAt': activityAt.toIso8601String(),
    'steps': steps,
    'calories': calories
  };
}

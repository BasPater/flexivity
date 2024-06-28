class DayActivity {
  final int steps;
  final double calories;

  DayActivity(this.steps, this.calories);

  factory DayActivity.fromJson(Map<String, dynamic> json) {
    return DayActivity(
      json['steps'] as int,
      json['calories'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
    'steps': steps,
    'calories': calories,
  };
}
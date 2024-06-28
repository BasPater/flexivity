import 'package:flexivity/data/models/activity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('toJson', () {
    test('toJson returns valid json', () {
      final activity = Activity(0, 0, 0, DateTime(2030));
      expect(activity.toJson(), {
        'activityId': 0,
        'activityAt': '2030-01-01T00:00:00.000',
        'steps': 0,
        'calories': 0
      });
    });
  });

  group('fromJson', () {
    test('fromJson parsed json successfully', () {
      final json = {
        'activityId': 0,
        'activityAt': '2030-01-01T00:00:00.000',
        'steps': 0,
        'calories': 0.0
      };

      final activity = Activity.fromJson(json);
      expect(activity.activityId, 0);
      expect(activity.activityAt, DateTime(2030));
      expect(activity.steps, 0);
      expect(activity.calories, 0.0);
    });
  });
}

import 'package:flexivity/data/models/day_activity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DayActivity', () {
    final dayActivity = DayActivity(1000, 500.0);

    test('fromJson', () {
      final result = DayActivity.fromJson({
        'steps': 1000,
        'calories': 500.0,
      });
      expect(result.calories, dayActivity.calories);
      expect(result.steps, dayActivity.steps);
    });

    test('toJson', () {
      expect(
        dayActivity.toJson(),
        {
          'steps': 1000,
          'calories': 500,
        },
      );
    });
  });
}

import 'package:flexivity/data/models/requests/get_group_with_activity_at_date_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('toJson', () {
    test('toJson can serialize to json map', () {
      final date = DateTime.now();
      final request = GetGroupWithActivityAtDateRequest(
        date: date,
        groupId: 0,
      );

      expect(
        request.toJson(),
        {
          'groupId': 0,
          'date': date.toIso8601String(),
        }
      );
    });
  });
}

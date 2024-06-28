import 'package:flexivity/data/models/prediction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('prediction', () {
    Prediction prediction = Prediction(date: '2021-10-10', score: 10.0);
    test('description', () {
      expect(prediction.toJson(), {
        'date': '2021-10-10',
        'score': 10.0,
      });
    });
    test('fromJson should return a valid User object', () {
      final json = {
        'date': '2021-10-10',
        'score': 10.0
      };

      final userFromJson = Prediction.fromJson(json);

      expect(userFromJson.date, '2021-10-10');
      expect(userFromJson.score, 10.0);
    });
  });
}
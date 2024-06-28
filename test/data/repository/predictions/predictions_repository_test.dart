
import 'package:flexivity/data/models/prediction.dart';
import 'package:flexivity/data/remote/prediction/prediction_api.dart';
import 'package:flexivity/data/repositories/prediction/prediction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'predictions_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PredictionApi>()])
void main() {
  MockPredictionApi mockPredictionApi = MockPredictionApi();
  PredictionRepository predictionRepository = PredictionRepository(mockPredictionApi);
  group('Prediction repository', () {
    Prediction testPrediction = Prediction(date: '2021-10-10', score: 10.0);
    List<Prediction> predictions = [testPrediction];
    test('getUser returns a GetUserResponse', () async {
      when(mockPredictionApi.getPrediction()).thenAnswer((_) async => predictions);

      final result = await predictionRepository.getPrediction();

      verify(mockPredictionApi.getPrediction());
      expect(result, equals(predictions));
    });
    test('getUser returns a GetUserResponse', () async {
      when(mockPredictionApi.getGoal(any)).thenAnswer((_) async => "1234");

      final result = await predictionRepository.getAIGoal(10000);
      expect(result, equals("1234"));
    });
  });
}
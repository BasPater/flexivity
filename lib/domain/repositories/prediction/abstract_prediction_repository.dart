
import '../../../data/models/prediction.dart';

abstract interface class IPredictionRepository {
  Future<List<Prediction>> getPrediction();
  Future<String> getAIGoal(int stepGoal);
}
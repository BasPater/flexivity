
import '../../models/prediction.dart';

abstract interface class IPredictionApi {
  Future<List<Prediction>> getPrediction();
  Future<String> getGoal(int goal);
}
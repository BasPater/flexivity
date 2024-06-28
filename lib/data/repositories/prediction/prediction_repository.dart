
import 'package:flexivity/data/models/prediction.dart';
import 'package:flexivity/domain/repositories/prediction/abstract_prediction_repository.dart';

import '../../remote/prediction/abstract_prediction_api.dart';

class PredictionRepository implements IPredictionRepository {

  final IPredictionApi api;

  const PredictionRepository(this.api);

  @override
  Future<List<Prediction>> getPrediction() {
    return api.getPrediction();
  }

  @override
  Future<String> getAIGoal(int stepGoal) {
   return api.getGoal(stepGoal);
  }

}
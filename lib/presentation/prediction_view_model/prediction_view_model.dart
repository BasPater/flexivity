import 'package:flexivity/app/views/prediction_view/prediction_view.dart';
import 'package:flexivity/data/models/prediction.dart';
import 'package:flexivity/domain/repositories/prediction/abstract_prediction_repository.dart';
import 'package:flexivity/domain/repositories/preferences/abstract_preferences_repository.dart';
import 'package:flutter/material.dart';

import '../../app/models/ui_state.dart';

// ignore: must_be_immutable
class PredictionViewModel extends StatefulWidget {
  List<Prediction> predictions;
  final IPredictionRepository predictionRepository;
  final IPreferencesRepository preferencesRepository;

  PredictionViewModel({
    super.key,
    required this.predictionRepository,
    required this.preferencesRepository,
  })  : this.uiState = UIState.loading,
        this.predictions = List.empty(growable: true);
  UIState uiState;
  int currentStepGoal = 0;
  int suggestedStepGoal = 0;

  @override
  State<PredictionViewModel> createState() => PredictionScreen();

  loadData(BuildContext context) async {
    try {
      currentStepGoal =
          int.parse(await preferencesRepository.getStepGoal() ?? '0');
      List<Future> futures = [loadAIData(), loadAIGoalData(currentStepGoal)];
      List results = await Future.wait(futures);
      predictions.addAll(results[0] as List<Prediction>);
      suggestedStepGoal = int.parse(results[1] as String);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Prediction>> loadAIData() async {
    try {
      return await this.predictionRepository.getPrediction();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<String> loadAIGoalData(int goal) async {
    try {
      return await this.predictionRepository.getAIGoal(goal);
    } catch (e) {
      return Future.error(e);
    }
  }

  void setStepGoal(int stepGoal) {
    preferencesRepository.setStepGoal(stepGoal.toString());
  }
}

import 'package:flexivity/data/remote/preferences/abstract_preferences_api.dart';
import 'package:flexivity/data/remote/preferences/preferences_api.dart';
import 'package:flexivity/domain/repositories/preferences/abstract_preferences_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PreferencesRepository implements IPreferencesRepository {

  final IPreferencesApi api;

  PreferencesRepository({IPreferencesApi? api})
      : api = api ?? PreferencesApi(const FlutterSecureStorage());

  /// Get steps from the secure storage
  @override
  Future<String?> getStepGoal() {
    return api.getStepGoal();
  }

  /// Get steps in the secure storage
  @override
  void setStepGoal(String goal) {
    api.setStepGoal(goal);
  }

}
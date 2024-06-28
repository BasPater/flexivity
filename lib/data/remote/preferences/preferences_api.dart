import 'package:flexivity/data/remote/preferences/abstract_preferences_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PreferencesApi implements IPreferencesApi {
  static const stepGoalKey = "goal";

  final FlutterSecureStorage prefs;

  PreferencesApi(this.prefs);

  @override
  Future<String?> getStepGoal() async {
    return prefs.read(key: stepGoalKey);
  }

  @override
  void setStepGoal(String goal) {
    prefs.write(key: stepGoalKey, value: goal);
  }

}
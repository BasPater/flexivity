abstract interface class IPreferencesApi {
  void setStepGoal(String goal);
  Future<String?> getStepGoal();
}
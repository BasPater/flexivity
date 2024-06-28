abstract interface class IPreferencesRepository {
  void setStepGoal(String goal);
  Future<String?> getStepGoal();
}
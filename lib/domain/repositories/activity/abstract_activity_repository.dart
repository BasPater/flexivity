import 'package:flexivity/data/models/activity.dart';

abstract class IActivityRepository {
  Future<Activity?> getActivity(int userId);
  Future<List<Activity>> getActivities(int userId, int from, int to);
  Future<void> saveActivity(Activity activity);
}

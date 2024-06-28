import 'dart:io';

import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/models/errors/http_api_exception.dart';
import 'package:flexivity/data/remote/activity/abstract_activity_api.dart';
import 'package:flexivity/domain/repositories/activity/abstract_activity_repository.dart';

class ActivityRepository extends IActivityRepository {
  final IActivityApi activityApi;

  ActivityRepository(this.activityApi);

  /// Gets a specific user activity
  @override
  Future<Activity?> getActivity(int userId) {
    return activityApi.getActivity(userId);
  }

  /// Gets the user's activities from the back-end for a given range
  @override
  Future<List<Activity>> getActivities(int userId, int from, int to) async {
    try {
      return await activityApi.getActivities(userId, from, to);
    } on HttpApiException catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        return List.empty();
      }

      return Future.error(e);
    }
  }

  @override
  Future<void> saveActivity(Activity activity) {
    return activityApi.saveActivity(activity);
  }
}

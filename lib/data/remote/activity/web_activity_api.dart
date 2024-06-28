import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/remote/activity/abstract_activity_api.dart';
import 'package:flexivity/data/remote/base/http_api.dart';
import 'package:http/http.dart';

class WebActivityApi extends HttpApi implements IActivityApi {
  WebActivityApi(super._client, super._credentials);

  /// Not implemented for the web api
  @override
  Future<Activity> getActivity(int userId) {
    throw UnimplementedError();
  }

  /// Gets the user's activities from the back-end server
  @override
  Future<List<Activity>> getActivities(
    int userId,
    int from,
    int to,
  ) async {
    Response response = await super.post(
      'api/v1/activity?from=$from&to=$to',
      body: {"userId": super.credentials!.userId.toString()},
    );

    // Check if the request was successful
    if (response.statusCode != HttpStatus.ok) {
      return Future.error(
        super.createHttpException(response, 'Error during request'),
      );
    }

    // Parse json body
    List<dynamic> json = jsonDecode(response.body);
    return json.map((value) => Activity.fromJson(value)).toList();
  }

  @override
  Future<void> saveActivity(Activity activity) async {
    final response = await super.post(
      'api/v1/activity/save',
      body: {
        'userId': super.credentials!.userId,
        'activityAt': activity.activityAt.toIso8601String().split('T')[0],
        'steps': activity.steps,
        'calories': activity.calories,
      },
    );

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(
        super.createHttpException(response, 'Error during request'),
      );
    }
  }
}

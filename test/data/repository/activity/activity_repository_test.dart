import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/models/errors/http_api_exception.dart';
import 'package:flexivity/data/remote/activity/web_activity_api.dart';
import 'package:flexivity/data/repositories/activity/activity_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'activity_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WebActivityApi>()])
void main() {
  group('getActivity', () {
    test(
      'getActivity completes normally',
      () async {
        await expectLater(
          ActivityRepository(MockWebActivityApi()).getActivity(0),
          completion(isA<Activity>()),
        );
      },
    );
  });

  group('getActivities', () {
    test(
      'getActivities completes normally',
      () async {
        await expectLater(
          ActivityRepository(MockWebActivityApi()).getActivities(0, 0, 1),
          completion(isA<List<Activity>>()),
        );
      },
    );

    test(
      'getActivities returns an empty list when 404 NotFound is received',
      () async {
        final activityApi = MockWebActivityApi();
        when(activityApi.getActivities(any, any, any)).thenAnswer(
          (_) => Future.error(const HttpApiException('message', 404)),
        );

        await expectLater(
          ActivityRepository(activityApi).getActivities(0, 0, 10),
          completion((List<Activity> value) => value.isEmpty),
        );

        reset(activityApi);
      },
    );

    test(
      'getActivities returns HttpApiException when the returned status code is not 200, 403 or 404',
      () async {
        final activityApi = MockWebActivityApi();
        when(activityApi.getActivities(any, any, any)).thenAnswer(
          (_) => Future.error(const HttpApiException('message', 401)),
        );

        expect(
          () => ActivityRepository(activityApi).getActivities(0, 0, 10),
          throwsA(
            isA<HttpApiException>().having(
              (e) => e.statusCode,
              'statusCode',
              401,
            ),
          ),
        );

        reset(activityApi);
      },
    );
  });

  group('saveActivity', () {
    test(
      'saveActivity completes normally',
      () async {
        await expectLater(
          ActivityRepository(MockWebActivityApi()).saveActivity(Activity(0, 0, 0.0, DateTime.now())),
          completes,
        );
      },
    );
  });
}

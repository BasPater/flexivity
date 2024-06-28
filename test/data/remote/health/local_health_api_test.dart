import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/models/errors/api_permission_exception.dart';
import 'package:flexivity/data/remote/health/local_health_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Health>()])
import 'local_health_api_test.mocks.dart';

void main() {
  final stepsDataPoint = HealthDataPoint(
    value: NumericHealthValue(numericValue: 5),
    type: HealthDataType.STEPS,
    unit: HealthDataUnit.COUNT,
    dateFrom: DateTime.now(),
    dateTo: DateTime.now(),
    sourcePlatform: HealthPlatformType.googleHealthConnect,
    sourceDeviceId: 'gerry',
    sourceId: 'gerry',
    sourceName: 'gerry',
  );

  final caloriesDataPoint = HealthDataPoint(
    value: NumericHealthValue(numericValue: 5),
    type: HealthDataType.ACTIVE_ENERGY_BURNED,
    unit: HealthDataUnit.LARGE_CALORIE,
    dateFrom: DateTime(2030),
    dateTo: DateTime(2030),
    sourcePlatform: HealthPlatformType.googleHealthConnect,
    sourceDeviceId: '5646456',
    sourceId: '56757567',
    sourceName: '78678678',
  );

  group('getActivity', () {
    test('getActivity can get activity', () {
      final health = MockHealth();
      when(health.hasPermissions(any)).thenAnswer((_) => Future.value(true));
      when(health.getHealthDataFromTypes(
        types: anyNamed('types'),
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      )).thenAnswer((_) => Future.value([stepsDataPoint, caloriesDataPoint]));

      expectLater(
        LocalHealthApi(health).getTodaysHealthData(),
        completion(
          (value) =>
              value.toString() == Activity(0, 5, 5, DateTime(2030)).toString(),
        ),
      );
    });

    test('getActivity calls installHealthConnect when not installed', () async {
      final health = MockHealth();
      when(health.getHealthConnectSdkStatus()).thenAnswer(
          (_) => Future.value(HealthConnectSdkStatus.sdkUnavailable));
      when(health.hasPermissions(any)).thenAnswer((_) => Future.value(true));
      when(health.getHealthDataFromTypes(
        types: anyNamed('types'),
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      )).thenAnswer((_) => Future.value([stepsDataPoint, caloriesDataPoint]));

      await LocalHealthApi(health).getTodaysHealthData();
      verify(health.installHealthConnect()).called(1);
    });

    test(
      'getActivity throws ApiPermissionException when no permissions were given',
      () {
        final health = MockHealth();
        when(health.hasPermissions(any)).thenAnswer((_) => Future.value(false));

        expect(
          () => LocalHealthApi(health).getTodaysHealthData(),
          throwsA(
            isA<ApiPermissionException>().having(
              (e) => e.message,
              'message',
              'Did not get permission for requested health data',
            ),
          ),
        );
      },
    );
  });
}
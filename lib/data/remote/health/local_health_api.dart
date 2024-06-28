import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/models/errors/api_permission_exception.dart';
import 'package:flexivity/data/remote/health/abstract_health_api.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

class LocalHealthApi implements IHealthApi {
  final Health healthApi;

  LocalHealthApi(this.healthApi) {
    healthApi.configure(useHealthConnectIfAvailable: true);
  }

  @override
  Future<Activity?> getTodaysHealthData() async {
    // Prompt the user to install Health Connect if it is not installed
    if (defaultTargetPlatform == TargetPlatform.android) {
      final healthConnectStatus = await healthApi.getHealthConnectSdkStatus();
      if (healthConnectStatus != HealthConnectSdkStatus.sdkAvailable) {
        healthApi.installHealthConnect();
      }
    }

    // Request access to data types
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    bool? hasPermissions = await healthApi.hasPermissions(types);
    if (hasPermissions == null || !hasPermissions) {
      if (!await healthApi.requestAuthorization(types)) {
        return Future.error(
          const ApiPermissionException(
            'Did not get permission for requested health data',
          ),
        );
      }
    }

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 1);
    List<HealthDataPoint> healthData = await healthApi.getHealthDataFromTypes(
      types: [HealthDataType.ACTIVE_ENERGY_BURNED],
      startTime: startOfDay,
      endTime: now,
    );

    return _parseHealthData(
      healthData,
      await healthApi.getTotalStepsInInterval(startOfDay, now),
    );
  }

  Activity? _parseHealthData(List<HealthDataPoint> dataPoints, int? readSteps) {
    int steps = readSteps ?? 0;
    double calories = 0.0;

    // Run through data points and add them up
    for (var dataPoint in dataPoints) {
      if (dataPoint.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
        calories +=
            (dataPoint.value as NumericHealthValue).numericValue.toDouble();
      }
    }

    if (steps == 0 && calories == 0.0) {
      return null;
    }

    return Activity(0, steps, calories, DateTime.now());
  }
}

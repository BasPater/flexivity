import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/remote/activity/web_activity_api.dart';
import 'package:flexivity/data/remote/health/local_health_api.dart';
import 'package:flexivity/data/repositories/activity/activity_repository.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flexivity/data/repositories/health/health_repository.dart';
import 'package:flexivity/domain/service/hourly_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:health/health.dart';
import 'package:http/http.dart';
import 'package:workmanager/workmanager.dart';

class ActivityBackgroundService extends HourlyBackgroundService {
  HealthRepository? healthRepo;
  CredentialsRepository? credRepo;
  ActivityRepository? activityRepo;

  ActivityBackgroundService({
    required Workmanager workmanager,
    this.healthRepo,
    this.credRepo,
    this.activityRepo,
  }) : super(
          workmanager,
          'ActivityBackgroundService',
          'SaveTodaysActivity',
        );

  /// The main function for the activity background service
  @override
  Future<bool> run(String taskName, Map<String, dynamic>? data) async {
    dotenv.load();
    final credRepo = this.credRepo ?? CredentialsRepository();
    if (!await credRepo.hasCredentials()) {
      return Future.error('Not logged in');
    }
    final credentials = await credRepo.getCredentials();

    final healthRepo = this.healthRepo ??
        HealthRepository(
          LocalHealthApi(Health()),
        );
    final activityRepo = this.activityRepo ??
        ActivityRepository(
          WebActivityApi(Client(), credentials),
        );

    Activity? today = await healthRepo.getTodaysActivity();
    if (today == null) {
      return Future.error('No activity found');
    }

    await activityRepo.saveActivity(today);
    return true;
  }
}

import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/repositories/activity/activity_repository.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flexivity/data/repositories/health/health_repository.dart';
import 'package:flexivity/domain/service/background_service_handler.dart'
    as serviceHandler;
import 'package:flexivity/domain/service/activity_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workmanager/workmanager.dart';

@GenerateNiceMocks([
  MockSpec<Workmanager>(),
  MockSpec<HealthRepository>(),
  MockSpec<ActivityRepository>(),
  MockSpec<CredentialsRepository>(),
])
import 'activity_background_service_test.mocks.dart';

void main() {
  group('start', () {
    test(
      'Start can automatically initialize workmanager',
      () async {
        dotenv.testLoad();
        final workmanager = MockWorkmanager();
        final service = ActivityBackgroundService(workmanager: workmanager);

        await service.start();
        final initializeRun = verify(
          workmanager.initialize(
            captureAny,
            isInDebugMode: anyNamed('isInDebugMode'),
          ),
        );

        expect(initializeRun.callCount, 1);
        expect(
          initializeRun.captured.first,
          serviceHandler.backgroundServiceHandler,
        );
      },
    );

    test(
      'start Starts the service correctly',
      () async {
        dotenv.testLoad();
        final workmanager = MockWorkmanager();
        final service = ActivityBackgroundService(workmanager: workmanager);

        await service.start();
        final registerTaskRun = verify(
          workmanager.registerPeriodicTask(
            captureAny,
            captureAny,
            frequency: captureAnyNamed('frequency'),
            initialDelay: anyNamed('initialDelay'),
            constraints: anyNamed('constraints'),
          ),
        );

        expect(registerTaskRun.callCount, 1);
        expect(registerTaskRun.captured[0], 'ActivityBackgroundService');
        expect(registerTaskRun.captured[1], 'SaveTodaysActivity');
        expect(serviceHandler.services, contains('SaveTodaysActivity'));
      },
    );
  });

  group('cancel', () {
    test(
      'cancel Can cancel the service',
      () async {
        dotenv.testLoad();
        final workmanager = MockWorkmanager();
        final service = ActivityBackgroundService(workmanager: workmanager);

        await service.cancel();
        final cancelRun = verify(workmanager.cancelByUniqueName(captureAny));

        expect(cancelRun.callCount, 1);
        expect(cancelRun.captured.first, 'ActivityBackgroundService');
      },
    );
  });

  group('run', () {
    test(
      'run Can save todays activity',
      () async {
        final healthRepo = MockHealthRepository();
        final credRepo = MockCredentialsRepository();
        final activityRepo = MockActivityRepository();
        final workmanager = MockWorkmanager();
        final service = ActivityBackgroundService(
          workmanager: workmanager,
          healthRepo: healthRepo,
          activityRepo: activityRepo,
          credRepo: credRepo,
        );

        when(credRepo.hasCredentials()).thenAnswer((_) async => true);
        when(credRepo.getCredentials()).thenAnswer(
          (_) async => Credentials(0, '', ''),
        );
        when(healthRepo.getTodaysActivity()).thenAnswer(
          (_) async => Activity(0, 0, 0, DateTime.now()),
        );

        await service.run('SaveTodaysActivity', null);
        final saveResult = verify(activityRepo.saveActivity(captureAny));
        expect(saveResult.captured.first, isNotNull);
      },
    );

    test(
      'run Returns the correct message when the user is not logged in',
      () async {
        final healthRepo = MockHealthRepository();
        final credRepo = MockCredentialsRepository();
        final activityRepo = MockActivityRepository();
        final workmanager = MockWorkmanager();
        final service = ActivityBackgroundService(
          workmanager: workmanager,
          healthRepo: healthRepo,
          activityRepo: activityRepo,
          credRepo: credRepo,
        );

        when(credRepo.hasCredentials()).thenAnswer((_) async => false);
        expectLater(
          service.run('SaveTodaysActivity', null),
          throwsA('Not logged in'),
        );
      },
    );

    test(
      'run Returns the correct error message when no activity is found for today',
      () {
        final healthRepo = MockHealthRepository();
        final credRepo = MockCredentialsRepository();
        final activityRepo = MockActivityRepository();
        final workmanager = MockWorkmanager();
        final service = ActivityBackgroundService(
          workmanager: workmanager,
          healthRepo: healthRepo,
          activityRepo: activityRepo,
          credRepo: credRepo,
        );

        when(credRepo.hasCredentials()).thenAnswer((_) async => true);
        when(credRepo.getCredentials()).thenAnswer(
          (_) async => Credentials(0, '', ''),
        );
        when(healthRepo.getTodaysActivity()).thenAnswer((_) async => null);

        expectLater(
          service.run('SaveTodaysActivity', null),
          throwsA('No activity found'),
        );
      },
    );
  });
}

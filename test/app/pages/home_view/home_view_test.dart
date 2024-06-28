import 'dart:math';

import 'package:flexivity/app/router/router.dart';
import 'package:flexivity/app/views/home_view/widgets/activity_list.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_authentication_exception.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/repositories/activity/activity_repository.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flexivity/data/repositories/health/health_repository.dart';
import 'package:flexivity/data/repositories/preferences/preferences_repository.dart';
import 'package:flexivity/data/repositories/authentication/web_authentication_repository.dart';
import 'package:flexivity/presentation/home_view_model/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<HealthRepository>(),
  MockSpec<ActivityRepository>(),
  MockSpec<WebAuthenticationRepository>(),
  MockSpec<CredentialsRepository>(),
  MockSpec<PreferencesRepository>(),
])
import 'home_view_test.mocks.dart';

void main() {
  tearDown(() => Globals.credentials = null);

  testWidgets(
    'HomeView loads',
    (tester) async {
      Globals.credentials = const Credentials(0, '', '');

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MaterialApp.router(
            builder: (context, _) => HomeViewModel(
              healthRepo: getMockHealthRepo(),
              activityRepo: getMockActivityRepo(),
              prefRepo: MockPreferencesRepository(),
            ),
            routerConfig: routerConfig(credentials: Credentials(0, '', '')),
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // Verify that the Scrollable widget is created
      expect(
        find.byWidgetPredicate((widget) => widget is SingleChildScrollView),
        findsOneWidget,
      );

      // Verify that the ActivityList loads
      expect(
        find.byWidgetPredicate((widget) => widget is ActivityList),
        findsOneWidget,
      );
    },
  );

  group('loadData', () {
    testWidgets(
      'loadData can initialize step goal',
      (tester) async {
        Globals.credentials = const Credentials(0, '', '');
        final prefRepo = MockPreferencesRepository();
        when(prefRepo.getStepGoal()).thenAnswer((_) => Future.value('500'));

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: MaterialApp.router(
              builder: (context, _) => HomeViewModel(
                healthRepo: getMockHealthRepo(),
                activityRepo: getMockActivityRepo(),
                prefRepo: prefRepo,
              ),
              routerConfig: routerConfig(credentials: Credentials(0, '', '')),
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Verify that the ActivityList loads
        expect(
          find.byWidgetPredicate((widget) => widget is ActivityList),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'loadData shows snackbar when todays activity cannot be loaded',
      (tester) async {
        Globals.credentials = const Credentials(0, '', '');
        final healthRepo = getMockHealthRepo();
        when(healthRepo.getTodaysActivity())
            .thenThrow(ApiException('Snackbar message'));

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: MaterialApp.router(
              builder: (context, _) => HomeViewModel(
                healthRepo: healthRepo,
                activityRepo: getMockActivityRepo(),
                prefRepo: MockPreferencesRepository(),
              ),
              routerConfig: routerConfig(credentials: Credentials(0, '', '')),
            ),
          ),
        ));

        await tester.pump();
        expect(find.text('Snackbar message'), findsOneWidget);
      },
    );

    testWidgets(
      'loadData can initialize empty Activity when no data is found',
      (tester) async {
        Globals.credentials = const Credentials(0, '', '');

        final healthRepo = getMockHealthRepo();
        when(healthRepo.getTodaysActivity())
            .thenAnswer((_) => Future.value(null));

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: MaterialApp.router(
              builder: (context, _) => HomeViewModel(
                healthRepo: healthRepo,
                activityRepo: getMockActivityRepo(),
                prefRepo: MockPreferencesRepository(),
              ),
              routerConfig: routerConfig(credentials: Credentials(0, '', '')),
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Verify that the ActivityList loads
        expect(
          find.byWidgetPredicate((widget) => widget is ActivityList),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'loadData logs the user out when an ApiAuthenticationException is thrown',
      (tester) async {
        Globals.credentials = const Credentials(0, '', '');

        final activityRepo = getMockActivityRepo();
        when(activityRepo.getActivities(any, any, any)).thenAnswer(
            (_) => Future.error(const ApiAuthenticationException('')));

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: MaterialApp.router(
              builder: (context, _) => HomeViewModel(
                healthRepo: getMockHealthRepo(),
                activityRepo: activityRepo,
                prefRepo: MockPreferencesRepository(),
                credRepo: MockCredentialsRepository(),
              ),
              routerConfig: routerConfig(credentials: Credentials(0, '', '')),
            ),
          ),
        ));

        // Wait until the page is loaded
        await tester.pumpAndSettle();

        expect(Globals.credentials, null);
      },
    );

    testWidgets(
      'loadData shows a snackbar when an ApiException is thrown',
      (tester) async {
        Globals.credentials = const Credentials(0, '', '');

        final activityRepo = getMockActivityRepo();
        when(activityRepo.getActivities(any, any, any)).thenThrow(
          const ApiException('Snackbar message'),
        );

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: MaterialApp.router(
              builder: (context, _) => HomeViewModel(
                healthRepo: getMockHealthRepo(),
                activityRepo: activityRepo,
                prefRepo: MockPreferencesRepository(),
              ),
              routerConfig: routerConfig(credentials: Credentials(0, '', '')),
            ),
          ),
        ));

        // Wait until the page is loaded
        await tester.pump();
        expect(find.text('Snackbar message'), findsOneWidget);
      },
    );
  });

  group('load more activities', () {
    testWidgets(
      'Load more can load new Activities',
      (tester) async {
        Globals.credentials = const Credentials(0, '', '');

        final activityRepo = getMockActivityRepo();
        when(activityRepo.getActivities(any, any, any)).thenAnswer(
          (_) => Future.value(
            List<Activity>.filled(
              10,
              Activity(
                0,
                0,
                0,
                DateTime(
                  Random(DateTime.now().microsecondsSinceEpoch).nextInt(30) +
                      2000,
                ),
              ),
            ),
          ),
        );

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: MaterialApp.router(
              builder: (context, _) => HomeViewModel(
                healthRepo: getMockHealthRepo(),
                activityRepo: activityRepo,
                prefRepo: MockPreferencesRepository(),
              ),
              routerConfig: routerConfig(credentials: Credentials(0, '', '')),
            ),
          ),
        ));

        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Load more'));
        await tester.tap(find.text('Load more'));
        await tester.pumpAndSettle();

        // Verify that the ActivityList loads
        expect(
          find.byWidgetPredicate((widget) => widget is ActivityList),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Load more logs the user out when an ApiAuthenticationException is thrown',
      (tester) async {
        Globals.credentials = const Credentials(0, '', '');

        final activityRepo = getMockActivityRepo();
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: MaterialApp.router(
              builder: (context, _) => HomeViewModel(
                healthRepo: getMockHealthRepo(),
                activityRepo: activityRepo,
                prefRepo: MockPreferencesRepository(),
                credRepo: MockCredentialsRepository(),
              ),
              routerConfig: routerConfig(credentials: Credentials(0, '', '')),
            ),
          ),
        ));

        // Wait until the page is loaded
        await tester.pumpAndSettle();
        expect(Globals.credentials, isNotNull);

        when(activityRepo.getActivities(any, any, any)).thenAnswer(
            (_) => Future.error(const ApiAuthenticationException('')));

        await tester.ensureVisible(find.text('Load more'));
        await tester.tap(find.text('Load more'));
        await tester.pumpAndSettle();
        expect(Globals.credentials, null);
      },
    );

    testWidgets(
      'Load more shows a snackbar when an ApiException is thrown',
      (tester) async {
        Globals.credentials = const Credentials(0, '', '');

        final activityRepo = getMockActivityRepo();
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: MaterialApp.router(
              builder: (context, _) => HomeViewModel(
                healthRepo: getMockHealthRepo(),
                activityRepo: activityRepo,
                prefRepo: MockPreferencesRepository(),
                credRepo: MockCredentialsRepository(),
              ),
              routerConfig: routerConfig(credentials: Credentials(0, '', '')),
            ),
          ),
        ));

        // Wait until the page is loaded
        await tester.pumpAndSettle();
        expect(Globals.credentials, isNotNull);

        when(activityRepo.getActivities(any, any, any))
            .thenThrow(const ApiException('Snackbar message'));

        await tester.ensureVisible(find.text('Load more'));
        await tester.tap(find.text('Load more'));
        await tester.pumpAndSettle();
        expect(find.text('Snackbar message'), findsOne);
      },
    );
  });
}

MockCredentialsRepository getMockCredRepo() {
  var repo = MockCredentialsRepository();
  when(repo.hasCredentials()).thenAnswer((_) => Future.value(true));
  when(repo.getCredentials()).thenAnswer(
    (_) => Future.value(const Credentials(0, '', '')),
  );

  return repo;
}

MockHealthRepository getMockHealthRepo() {
  final repo = MockHealthRepository();
  when(repo.getTodaysActivity())
      .thenAnswer((_) => Future.value(Activity(0, 0, 0, DateTime.now())));

  return repo;
}

MockActivityRepository getMockActivityRepo() {
  var repo = MockActivityRepository();
  when(repo.getActivity(any))
      .thenAnswer((_) => Future.value(Activity(0, 0, 0, DateTime.now())));
  when(repo.getActivities(any, any, any))
      .thenAnswer((_) => Future.value(List.empty()));

  return repo;
}

import 'package:flexivity/app/router/router.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/prediction.dart';
import 'package:flexivity/data/repositories/prediction/prediction_repository.dart';
import 'package:flexivity/data/repositories/preferences/preferences_repository.dart';
import 'package:flexivity/presentation/prediction_view_model/prediction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'prediction_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PredictionRepository>(),
  MockSpec<PreferencesRepository>(),
  MockSpec<PredictionViewModel>(),
  MockSpec<BuildContext>(),
])
void main() {
  tearDown(() => Globals.credentials = null);
  MockPredictionRepository mockPredictionRepository =
      MockPredictionRepository();
  MockPreferencesRepository mockPreferencesRepository =
      MockPreferencesRepository();
  PredictionViewModel viewModel = PredictionViewModel(
      predictionRepository: mockPredictionRepository,
      preferencesRepository: MockPreferencesRepository());
  MockPredictionViewModel mockViewModel = MockPredictionViewModel();
  MockBuildContext buildContext = MockBuildContext();
  final stepGoal = 10000;
  setUp(
    () {
      reset(mockPredictionRepository);
      reset(mockViewModel);
    },
  );

  group(
    'UI',
    () {
      testWidgets(
        'HomeView loads ',
        (tester) async {
          Globals.credentials = const Credentials(0, '', '');

          // Build our app and trigger a frame.
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: MaterialApp.router(
                  builder: (context, _) => PredictionViewModel(
                    predictionRepository: getPredictionRepository(),
                    preferencesRepository: mockPreferencesRepository,
                  ),
                  routerConfig:
                      routerConfig(credentials: Credentials(0, '', '')),
                ),
              ),
            ),
          );

          await tester.pump();

          // Verify that the Scrollable widget is created
          expect(
            find.byWidgetPredicate((widget) => widget is SingleChildScrollView),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'HomeView loads and presses button',
        (tester) async {
          Globals.credentials = const Credentials(0, '', '');

          // Build our app and trigger a frame.
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: MaterialApp.router(
                  builder: (context, _) => PredictionViewModel(
                    predictionRepository: getPredictionRepository(),
                    preferencesRepository: mockPreferencesRepository,
                  ),
                  routerConfig:
                      routerConfig(credentials: Credentials(0, '', '')),
                ),
              ),
            ),
          );

          await tester.pump();
          var sendButton =
              find.widgetWithText(FilledButton, "Apply suggestion");
          await tester.ensureVisible(sendButton);
          await tester.tap(sendButton);
          await tester.pump(); // Use pump instead of pumpAndSettle

          // Verify that the Scrollable widget is created
          expect(
            find.byWidgetPredicate((widget) => widget is SingleChildScrollView),
            findsOneWidget,
          );
          verify(mockPreferencesRepository.setStepGoal(any)).called(1);
        },
      );
    },
  );

  group(
    'Logic',
    () {
      test('getGroupsById returns ApiException', () {
        Globals.credentials = const Credentials(0, '', '');
        when(mockPredictionRepository.getPrediction())
            .thenThrow(ApiException('KWASH'));

        expectLater(
            viewModel.loadData(buildContext), throwsA(isA<ApiException>()));
      });
      test('getGoal returns ApiException', () {
        when(mockPredictionRepository.getAIGoal(stepGoal))
            .thenThrow(ApiException('KWASH'));

        expectLater(
            viewModel.loadAIGoalData(stepGoal), throwsA(isA<ApiException>()));
      });
    },
  );
}

MockPredictionRepository getPredictionRepository() {
  final mockPredictionRepository = MockPredictionRepository();
  when(mockPredictionRepository.getPrediction()).thenAnswer((_) async => [
        Prediction(date: '2023-01-01', score: 1.0), // Add mock data here
        // Add more mock data if needed
      ]);
  when(mockPredictionRepository.getAIGoal(any)).thenAnswer((_) async => '4321');
  return mockPredictionRepository;
}

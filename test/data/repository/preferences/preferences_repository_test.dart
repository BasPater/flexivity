import 'package:flexivity/data/remote/preferences/abstract_preferences_api.dart';
import 'package:flexivity/data/remote/preferences/preferences_api.dart';
import 'package:flexivity/data/repositories/preferences/preferences_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'preferences_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PreferencesApi>()])
void main() {
  group('PreferencesRepository', () {
    late IPreferencesApi api;
    late PreferencesRepository repository;

    setUp(() {
      api = MockPreferencesApi();
      repository = PreferencesRepository(api: api);
    });

    test('getStepGoal returns value from api', () async {
      when(api.getStepGoal()).thenAnswer((_) async => '1000');

      final result = await repository.getStepGoal();

      expect(result, '1000');
      verify(api.getStepGoal()).called(1);
    });

    test('setStepGoal calls api with correct value', () {
      const goal = '2000';

      repository.setStepGoal(goal);

      verify(api.setStepGoal(goal)).called(1);
    });

    test('uses provided IPreferencesApi instance if given', () {
      final repo = PreferencesRepository(api: api);

      expect(repo.api, equals(api));
    });

    test('creates new PreferencesApi instance if no IPreferencesApi given', () {
      final repo = PreferencesRepository();

      expect(repo.api, isA<PreferencesApi>());
    });
  });
}

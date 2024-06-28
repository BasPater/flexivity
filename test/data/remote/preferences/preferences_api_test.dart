import 'package:flexivity/data/remote/preferences/preferences_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'preferences_api_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
void main() {
  group('PreferencesApi', () {
    late PreferencesApi preferencesApi;
    late MockFlutterSecureStorage mockStorage;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      preferencesApi = PreferencesApi(mockStorage);
    });

    test('should get step goal', () async {
      when(mockStorage.read(key: anyNamed('key'))).thenAnswer((_) async => '1000');

      final result = await preferencesApi.getStepGoal();

      verify(mockStorage.read(key: 'goal'));
      expect(result, equals('1000'));
    });

    test('should set step goal', () {
      preferencesApi.setStepGoal('2000');

      verify(mockStorage.write(key: 'goal', value: '2000'));
    });
  });
}
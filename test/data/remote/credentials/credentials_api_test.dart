import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/remote/credentials/local_credentials_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'credentials_api_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
void main() {
  final storage = MockFlutterSecureStorage();

  group('setCredentials', () {
    test('setCredentials completes normally', () async {
      expect(
          () =>
              LocalCredentialsApi(storage).setCredentials(1, 'token', 'token'),
          returnsNormally);
    });
  });

  group('getCredentials', () {
    test('getCredentials completes normally', () async {
      var api = LocalCredentialsApi(storage);

      when(storage.read(key: 'user_id')).thenAnswer((_) async => '1');
      when(storage.read(key: 'access_token')).thenAnswer((_) async => 'test');
      when(storage.read(key: 'refresh_token')).thenAnswer((_) async => 'test');
      await expectLater(api.getCredentials(), completion(isA<Credentials>()));
      reset(storage);
    });

    test('getCredentials throws exception when empty', () async {
      expect(
        () => LocalCredentialsApi(storage).getCredentials(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('deleteCredentials', () {
    test('deleteCredentials completes normally', () async {
      expect(() => LocalCredentialsApi(storage).deleteCredentials(),
          returnsNormally);
    });
  });

  group('hasCredentials', () {
    test('hasCredentials returns true', () async {
      var api = LocalCredentialsApi(storage);

      when(storage.read(key: 'user_id')).thenAnswer((_) async => '1');
      when(storage.read(key: 'access_token')).thenAnswer((_) async => 'test');
      when(storage.read(key: 'refresh_token')).thenAnswer((_) async => 'test');
      await expectLater(api.hasCredentials(), completion(true));
      reset(storage);
    });

    test('hasCredentials returns false', () async {
      when(storage.read(key: 'user_id')).thenAnswer((_) async => null);
      when(storage.read(key: 'access_token')).thenAnswer((_) async => null);
      when(storage.read(key: 'refresh_token')).thenAnswer((_) async => null);
      await expectLater(
          LocalCredentialsApi(storage).hasCredentials(), completion(false));
      reset(storage);
    });
  });
}

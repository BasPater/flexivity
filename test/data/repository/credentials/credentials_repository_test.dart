import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/remote/credentials/local_credentials_api.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<LocalCredentialsApi>()])
import 'credentials_repository_test.mocks.dart';

void main() {
  final api = MockLocalCredentialsApi();

  group('setCredentials', () {
    test('setCredentials completes normally', () {
      expect(
        () => CredentialsRepository(api: api).setCredentials(1, '', ''),
        returnsNormally,
      );
    });
  });

  group('getCredentials', () {
    test('getCredentials completes normally', () {
      expectLater(
        CredentialsRepository(api: api).getCredentials(),
        completion(isA<Credentials>()),
      );
    });
  });

  group('deleteCredentials', () {
    test('deleteCredentials completes normally', () {
      expect(
        () => CredentialsRepository(api: api).deleteCredentials(),
        returnsNormally,
      );
    });
  });

  group('hasCredentials', () {
    test('hasCredentials completes normally', () {
      when(api.hasCredentials()).thenAnswer((_) async => true);
      expectLater(
        CredentialsRepository(api: api).hasCredentials(),
        completion(true),
      );
    });
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/new_user.dart';
import 'package:flexivity/data/models/responses/error_response.dart';
import 'package:flexivity/data/models/responses/login_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/remote/authentication/web_authentication_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';

@GenerateNiceMocks([MockSpec<Client>()])
import 'web_authentication_api_test.mocks.dart';

Stream<List<int>> toUtf8Stream(Object obj) {
  return Stream.value(utf8.encode(jsonEncode(obj)));
}

void main() {
  User user = User(0, 'test@test.test', 'test', 'test', 'test', 'USER');
  NewUser newUser =
      NewUser(0, 'test@test.test', 'test', 'test', 'test', 'USER', '@Test123');
  LoginResponse response = LoginResponse(user, 'token', '');

  group('register', () {
    test('Register can complete without errors', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = WebAuthenticationApi(client);
      when(client.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 200));
      expect(() async => await api.register(newUser), returnsNormally);
      reset(client);
    });

    test('Register fails on non 200 status codes', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = WebAuthenticationApi(client);
      when(client.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          Stream.value(
            utf8.encode(
              jsonEncode(ErrorResponse('Error', '', DateTime.now())),
            ),
          ),
          500,
        ),
      );
      expect(() => api.register(newUser), throwsA(isA<ApiException>()));
    });

    test('Register can timeout gracefully', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = WebAuthenticationApi(client);
      when(client.send(any)).thenThrow(
        const SocketException('TimeOut'),
      );
      expect(() => api.register(newUser), throwsA(isA<ApiException>()));
      reset(client);
    });

    test('Register can handle error body', () {
      dotenv.testLoad();
      final client = MockClient();
      final api = WebAuthenticationApi(client);
      when(client.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('error', '', DateTime.now())),
          500,
        ),
      );

      expect(
        () => api.register(newUser),
        throwsA(isA<ApiException>().having(
          (e) => e.message,
          'message',
          contains('error'),
        )),
      );
      reset(client);
    });
  });

  group('login', () {
    test('Login can complete without errors', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = WebAuthenticationApi(client);
      when(client.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(response),
          200,
        ),
      );
      expect(await api.login('test', 'test'), isA<LoginResponse>());
      reset(client);
    });

    test('Login fails on non 200 status codes', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = WebAuthenticationApi(client);
      when(client.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 403));
      expect(() => api.login('test', 'test'), throwsA(isA<ApiException>()));
      reset(client);
    });

    test('Login can timeout gracefully', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = WebAuthenticationApi(client);
      when(client.send(any)).thenThrow(const SocketException('TimeOut'));
      expect(() => api.login('test', 'test'), throwsA(isA<ApiException>()));
      reset(client);
    });

    test('Login can handle error body', () {
      dotenv.testLoad();
      final client = MockClient();
      final api = WebAuthenticationApi(client);
      when(client.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('error', '', DateTime.now())),
          500,
        ),
      );

      expect(
        () => api.login('test', 'test'),
        throwsA(isA<ApiException>().having(
          (e) => e.message,
          'message',
          contains('error'),
        )),
      );
      reset(client);
    });
  });
}

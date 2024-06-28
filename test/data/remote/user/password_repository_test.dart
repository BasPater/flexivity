import 'dart:io';

import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/responses/error_response.dart';
import 'package:flexivity/data/remote/user/password_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../activity/web_activity_api_test.mocks.dart';
import '../authentication/web_authentication_api_test.dart';

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  dotenv.testLoad();
  group('PasswordApi', () {
    final String  email = "test@test.com";
    final String  code = "123QGD";
    final String  password = "Kaas1234%";
    test('forgetPassword returns a success message', () async {
      final client = MockClient();
      final api = PasswordApi(client);
      when(client.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 200));
      expect(() async => await api.forgetPassword(email),
          returnsNormally);
      reset(client);
    });
  test('Register fails on non 200 status codes', () async {
    dotenv.testLoad();
    final client = MockClient();
    final api = PasswordApi(client);
    when(client.send(any)).thenAnswer(
          (_) async => StreamedResponse(
        Stream.empty(),
        200,
      ),
    );
    var result = await api.forgetPassword("test@test.test");
    expectLater(result, true);
  });
    test('Register can timeout gracefully', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = PasswordApi(client);
      when(client.send(any)).thenThrow(
        const SocketException('TimeOut'),
      );
      expect(() => api.forgetPassword(email), throwsA(isA<ApiException>()));
      reset(client);
    });
    test('forgetPassword returns a success message', () async {
      final client = MockClient();
      final api = PasswordApi(client);
      when(client.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 200));
      expect(() async => await api.checkPasswordResetCode(code),
          returnsNormally);
      reset(client);
    });
    test('Register fails on non 200 status codes', () async {
      final client = MockClient();
      final api = PasswordApi(client);
      when(client.send(any)).thenAnswer(
            (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('Error', '', DateTime.now())),
          400,
        ),
      );

      var result = await api.checkPasswordResetCode("123ADS");

      expectLater(result, false);
    });
    test('Register can timeout gracefully', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = PasswordApi(client);
      when(client.send(any)).thenThrow(
        const SocketException('TimeOut'),
      );
      expect(() => api.checkPasswordResetCode(code), throwsA(isA<ApiException>()));
      reset(client);
    });
    test('Register can timeout gracefully', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = PasswordApi(client);
      when(client.send(any)).thenThrow(
        const SocketException('TimeOut'),
      );
      expect(() => api.forgetPassword(email), throwsA(isA<ApiException>()));
      reset(client);
    });
    test('forgetPassword returns a success message', () async {
      final client = MockClient();
      final api = PasswordApi(client);
      when(client.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 200));
      expect(() async => await api.resetPassword(password,code),
          returnsNormally);
      reset(client);
    });
    test('Register fails on non 200 status codes', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = PasswordApi(client);
      when(client.send(any)).thenAnswer(
            (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('Error', '', DateTime.now())),
          400,
        ),
      );

      var result = await api.resetPassword("Kaas1234%", "123ADS");

      expectLater(result, false);
    });
    test('Register can timeout gracefully', () async {
      dotenv.testLoad();
      final client = MockClient();
      final api = PasswordApi(client);
      when(client.send(any)).thenThrow(
        const SocketException('TimeOut'),
      );
      expect(() => api.resetPassword(password,code), throwsA(isA<ApiException>()));
      reset(client);
    });
  });

}

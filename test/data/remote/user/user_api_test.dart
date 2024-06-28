import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/responses/get_user_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/remote/user/user_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_api_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  MockClient mockClient = MockClient();
  const testCredentials = Credentials(1, 'token', 'token');
  UserApi userApi = UserApi(mockClient, testCredentials);
  dotenv.testLoad();

  group('UserApi', () {
    final testUser =
        User(1, 'test@example.com', 'testuser', 'Test', 'User', 'admin');
    final getUserResponse = GetUserResponse(testUser);

    test('getUser returns a GetUserResponse', () async {
      when(
        mockClient.send(any),
      ).thenAnswer(
        (_) async => StreamedResponse(
          Stream.value(
            utf8.encode(
              '{"userId": 1, "email": "test@example.com", "username": "testuser", "firstname": "Test", "lastname": "User", "role": "admin"}',
            ),
          ),
          200,
        ),
      );

      final result = await userApi.getUser(1);

      verify(mockClient.send(any)).called(1);
      expect(result.user.userId, equals(getUserResponse.user.userId));
    });

    test('getUser returns an error when status code is not 200', () async {
      when(mockClient.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 404));

      expect(
          () async => await userApi.getUser(1), throwsA(isA<ApiException>()));
    });

    test('getUser throws SocketException when there is no internet', () async {
      when(mockClient.send(any))
          .thenThrow(const SocketException('Failed host lookup'));

      expect(
          () async => await userApi.getUser(1), throwsA(isA<ApiException>()));
    });
    test('getUser returns an error when status code is not 200', () async {
      when(mockClient.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 404));

      expect(() async => await userApi.deleteUser(1),
          throwsA(isA<ApiException>()));
    });
    test('getUser throws SocketException when there is no internet', () async {
      when(mockClient.send(any))
          .thenThrow(const SocketException('Failed host lookup'));

      expect(() async => await userApi.deleteUser(1),
          throwsA(isA<ApiException>()));
    });
    test('getUser returns a GetUserResponse', () async {
      when(mockClient.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 200));
      expect(() async => await userApi.deleteUser(1),
          returnsNormally);

    });
    test('getUser returns an error when status code is not 200', () async {
      when(mockClient.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 404));
      final testUser =
      User(1, 'test@example.com', 'testuser', 'Test', 'User', 'admin');
      expect(() async => await userApi.updateUser(testUser),
          throwsA(isA<ApiException>()));
    });
    test('getUser throws SocketException when there is no internet', () async {
      when(mockClient.send(any))
          .thenThrow(const SocketException('Failed host lookup'));
      User(1, 'test@example.com', 'testuser', 'Test', 'User', 'admin');
      expect(() async => await userApi.updateUser(testUser),
          throwsA(isA<ApiException>()));
    });
    test('getUser returns an error when status code is not 200', () async {
      when(mockClient.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 404));
      expect(() async => await userApi.changePassword("oldPassword", "newPassword"),
          throwsA(isA<ApiException>()));
    });
    test('getUser throws SocketException when there is no internet', () async {
      when(mockClient.send(any))
          .thenThrow(const SocketException('Failed host lookup'));
      expect(() async => await userApi.changePassword("oldPassword", "newPassword"),
          throwsA(isA<ApiException>()));
    });
    test('getUser returns a GetUserResponse', () async {
      when(mockClient.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 200));
      expect(() async => await userApi.changePassword("oldPassword", "newPassword"),
          returnsNormally);

    });
    test('getUser returns a GetUserResponse', () async {
      when(
        mockClient.send(any),
      ).thenAnswer(
            (_) async => StreamedResponse(
          Stream.value(
            utf8.encode(
              '{"userId": 1, "email": "test@example.com", "username": "testuser", "firstname": "Test", "lastname": "User", "role": "admin"}',
            ),
          ),
          200,
        ),
      );

      final result = await userApi.updateUser(testUser);
      expect(result.user.userId, equals(getUserResponse.user.userId));

    });
  });
}

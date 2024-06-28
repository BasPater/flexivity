import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/remote/user/password_api.dart';
import 'package:flexivity/data/repositories/user/password_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'password_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PasswordApi>()])
void main() {
  MockPasswordApi mockPasswordApi = MockPasswordApi();
  PasswordRepository passwordRepository = PasswordRepository(mockPasswordApi);

  group('passwordRepository', () {
    final String  email = "test@test.com";
    final String  code = "123QGD";
    final String  password = "Kaas1234%";
    var apiException = const ApiException('Test');

    test('getUser returns a GetUserResponse', () async {
      when(mockPasswordApi.forgetPassword(any)).thenAnswer((_) async => true);

      when(mockPasswordApi.forgetPassword(email)).thenAnswer((_) => Future.value(true));
      expect(() async => await mockPasswordApi.forgetPassword(email),
          returnsNormally);
    });

    test('Register throws ApiException', () async {
      when(mockPasswordApi.forgetPassword(any)).thenAnswer((_) => Future.error(apiException));
      expect(() => passwordRepository.forgetPassword(email), throwsA(isA<ApiException>()));
    });

    test('getUser returns a GetUserResponse', () async {
      when(mockPasswordApi.checkPasswordResetCode(any)).thenAnswer((_) async => true);

      when(mockPasswordApi.checkPasswordResetCode(code)).thenAnswer((_) => Future.value(true));
      expect(() async => await mockPasswordApi.checkPasswordResetCode(code),
          returnsNormally);
    });

    test('Register throws ApiException', () async {
      when(mockPasswordApi.checkPasswordResetCode(any)).thenAnswer((_) => Future.error(apiException));
      expect(() => passwordRepository.checkPasswordResetCode(code), throwsA(isA<ApiException>()));
    });
    test('getUser returns a GetUserResponse', () async {
      when(mockPasswordApi.resetPassword(any, any)).thenAnswer((_) async => true);

      when(mockPasswordApi.resetPassword(password, code)).thenAnswer((_) => Future.value(true));
      expect(() async => await mockPasswordApi.resetPassword(password, code),
          returnsNormally);
    });

    test('Register throws ApiException', () async {
      when(mockPasswordApi.resetPassword(any, any)).thenAnswer((_) => Future.error(apiException));
      expect(() => passwordRepository.resetPassword(password, code), throwsA(isA<ApiException>()));
    });
  });
}
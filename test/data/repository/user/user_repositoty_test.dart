import 'package:flexivity/data/models/responses/get_user_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/user/user_repository.dart';
import 'package:flexivity/data/remote/user/user_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repositoty_test.mocks.dart';


@GenerateNiceMocks([MockSpec<UserApi>()])
void main() {
  MockUserApi mockUserApi= MockUserApi();
  UserRepository userRepository = UserRepository(mockUserApi);

  group('UserRepository', () {
    final testUser = User(1, 'test@example.com', 'testuser', 'Test', 'User', 'admin');
    final getUserResponse = GetUserResponse(testUser);

    test('getUser returns a GetUserResponse', () async {
      when(mockUserApi.getUser(any)).thenAnswer((_) async => getUserResponse);

      final result = await userRepository.getUser(1);

      verify(mockUserApi.getUser(1));
      expect(result, equals(getUserResponse));
    });

    test('updateUser calls UserApi.updateUser', () async {
      final testUser =
      User(1, 'test@example.com', 'testuser', 'Test', 'User', 'admin');
      when(mockUserApi.updateUser(any)).thenAnswer((_) async => GetUserResponse(testUser));

      await userRepository.updateUser(testUser);

      verify(mockUserApi.updateUser(testUser));
    });

    test('deleteUser calls UserApi.deleteUser', () async {
      when(mockUserApi.deleteUser(any)).thenAnswer((_) async => null);

      await userRepository.deleteUser(1);

      verify(mockUserApi.deleteUser(1));
    });
    test('changePassword calls UserApi.changePassword', () async {
      when(mockUserApi.changePassword(any, any)).thenAnswer((_) async => null);

      await userRepository.changePassword("oldPassword", "newPassword");

      verify(mockUserApi.changePassword("oldPassword", "newPassword"));
    });
    test('changePassword calls UserApi.changePassword', () async {
      when(mockUserApi.changePassword(any, any)).thenAnswer((_) async => null);

      await userRepository.changePassword("oldPassword", "newPassword");

      verify(mockUserApi.changePassword("oldPassword", "newPassword"));
    });
  });
}
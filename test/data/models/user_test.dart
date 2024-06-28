import 'package:flexivity/data/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    final user = User(1, 'test@example.com', 'testuser', 'Test', 'User', 'admin');

    test('toJson should return a valid map', () {
      expect(user.toJson(), {
        'userId': 1,
        'email': 'test@example.com',
        'username': 'testuser',
        'firstname': 'Test',
        'lastname': 'User',
        'role': 'admin',
      });
    });

    test('fromJson should return a valid User object', () {
      final json = {
        'userId': 1,
        'email': 'test@example.com',
        'username': 'testuser',
        'firstname': 'Test',
        'lastname': 'User',
        'role': 'admin',
      };

      final userFromJson = User.fromJson(json);

      expect(userFromJson.userId, 1);
      expect(userFromJson.email, 'test@example.com');
      expect(userFromJson.userName, 'testuser');
      expect(userFromJson.firstName, 'Test');
      expect(userFromJson.lastName, 'User');
      expect(userFromJson.role, 'admin');
    });
  });
}
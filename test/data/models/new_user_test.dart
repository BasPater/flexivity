import 'package:flexivity/data/models/new_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NewUser', () {
    final newUser = NewUser(1, 'test@example.com', 'testuser', 'Test', 'User', 'admin', 'password123');

    test('toJson should return a valid map', () {
      expect(newUser.toJson(), {
        'userId': 1,
        'email': 'test@example.com',
        'username': 'testuser',
        'firstname': 'Test',
        'lastname': 'User',
        'role': 'admin',
        'password': 'password123',
      });
    });
  });
}
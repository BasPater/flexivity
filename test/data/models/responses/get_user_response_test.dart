import 'package:flexivity/data/models/responses/get_user_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetUserResponse', () {

    test('fromJson should return a valid GetUserResponse object', () {
      final json = {
        'userId': 1,
        'email': 'test@example.com',
        'username': 'testuser',
        'firstname': 'Test',
        'lastname': 'User',
        'createdGroups': [],
        'memberships': [],
        'friendshipsInitiated': [],
        'friendshipsReceived': [],
        'role': 'admin'
      };

      final getUserResponseFromJson = GetUserResponse.fromJson(json);

      expect(getUserResponseFromJson.user.userId, 1);
      expect(getUserResponseFromJson.user.email, 'test@example.com');
      expect(getUserResponseFromJson.user.userName, 'testuser');
      expect(getUserResponseFromJson.user.firstName, 'Test');
      expect(getUserResponseFromJson.user.lastName, 'User');
      expect(getUserResponseFromJson.user.role, 'admin');
    });
  });
}

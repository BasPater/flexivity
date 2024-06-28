import 'package:flexivity/data/models/responses/get_group_reponse.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetGroupResponseTest', () {
    test('fromJson', () {
      Map<String, dynamic> json = {
        'groupId': 1,
        'groupName': 'Test Group',
        'ownedBy': {
          'userId': 2,
          'email': 'test@test.com',
          'username': 'testuser',
          'firstname': 'Test',
          'lastname': 'User',
          'role': 'admin',
        },
        'userPosition': 1,
        'nr1': {
          'userId': 3,
          'email': 'nr1@test.com',
          'username': 'nr1user',
          'firstname': 'Nr1',
          'lastname': 'User',
          'role': 'member',
        },
      };

      GetGroupResponse response = GetGroupResponse.fromJson(json);

      expect(response.groupId, 1);
      expect(response.groupName, 'Test Group');
      expect(response.ownedBy.userId, 2);
      expect(response.userPosition, 1);
      expect(response.nr1.userId, 3);
    });

    test('toJson', () {
      User ownedBy = User(2, 'test@test.com', 'testuser', 'Test', 'User', 'admin');
      User nr1 = User(3, 'nr1@test.com', 'nr1user', 'Nr1', 'User', 'member');
      GetGroupResponse response = GetGroupResponse(1, 'Test Group', ownedBy, 1, nr1);

      Map<String, dynamic> json = response.toJson();

      expect(json['groupId'], 1);
      expect(json['groupName'], 'Test Group');
      expect(json['ownedBy']['userId'], 2);
      expect(json['userPosition'], 1);
      expect(json['nr1']['userId'], 3);
    });
  });
}
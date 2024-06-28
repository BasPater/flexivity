import 'package:flexivity/data/models/requests/create_group_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreateGroupRequest', () {
    test('should convert to json correctly', () {
      final request = CreateGroupRequest(groupName: 'Test Group', members: [1, 2, 3]);
      final json = request.toJson();

      expect(json, {
        'groupName': 'Test Group',
        'members': [1, 2, 3],
      });
    });

    test('should create from json correctly', () {
      final json = {
        'groupName': 'Test Group',
        'members': [1, 2, 3],
      };

      final request = CreateGroupRequest.fromJson(json);

      expect(request.groupName, 'Test Group');
      expect(request.members, [1, 2, 3]);
    });
  });
}
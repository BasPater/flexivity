
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FriendshipStatusFromJsonExtension', () {
    test('should return correct status from json', () {
      expect(FriendshipStatusFromJsonExtension.fromJson('accepted'), FriendshipStatus.accepted);
      expect(FriendshipStatusFromJsonExtension.fromJson('rejected'), FriendshipStatus.rejected);
      expect(FriendshipStatusFromJsonExtension.fromJson('blocked'), FriendshipStatus.blocked);
      expect(FriendshipStatusFromJsonExtension.fromJson('pending'), FriendshipStatus.pending);
      expect(FriendshipStatusFromJsonExtension.fromJson('unknown'), FriendshipStatus.pending);
    });
  });

  group('FriendshipStatusToJsonExtension', () {
    test('should return correct json from status', () {
      expect(FriendshipStatus.accepted.toJson(), 'ACCEPTED');
      expect(FriendshipStatus.rejected.toJson(), 'REJECTED');
      expect(FriendshipStatus.blocked.toJson(), 'BLOCKED');
      expect(FriendshipStatus.pending.toJson(), 'PENDING');
    });
  });
}
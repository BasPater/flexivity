import 'package:flexivity/data/models/friend.dart';
import 'package:flexivity/data/models/friendship_status.dart';

class Friendship {
  final int friendshipId;
  final Friend friend;
  final FriendshipStatus status;
  final int actionUserId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Friendship(
    this.friendshipId,
    this.friend,
    this.status,
    this.actionUserId,
    this.createdAt,
    this.updatedAt,
  );

  factory Friendship.fromJson(Map<String, dynamic> json) {
    return Friendship(
      json['friendshipId'],
      Friend.fromJson(json['friend']),
      FriendshipStatusFromJsonExtension.fromJson(json['status']),
      json['actionUserId'],
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'friendshipId': friendshipId,
        'friend': friend.toJson(),
        'status': status.toJson(),
        'actionUserId': actionUserId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

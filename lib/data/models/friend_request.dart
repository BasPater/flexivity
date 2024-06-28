import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/user.dart';

class FriendRequest {
  int friendshipId;
  User friend;
  FriendshipStatus status;
  int actionUserId;
  DateTime createdAt;
  DateTime updatedAt;

  FriendRequest({
    required this.friendshipId,
    required this.friend,
    required this.status,
    required this.actionUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      friendshipId: json['friendshipId'],
      friend: User.fromJson(json['friend']),
      status: FriendshipStatusFromJsonExtension.fromJson(json['status']),
      actionUserId: json['actionUserId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friendshipId': friendshipId,
      'friend': friend.toJson(),
      'status': status.toJson(),
      'actionUserId': actionUserId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

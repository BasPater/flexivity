import 'package:flexivity/data/models/friendship_status.dart';

class ResponseFriendshipRequest {
  final int userId;
  final int friendId;
  final FriendshipStatus status;

  ResponseFriendshipRequest(this.userId, this.friendId, this.status);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'friendId': friendId,
      'status': status.toJson(),
    };
  }
}

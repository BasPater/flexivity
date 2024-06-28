import 'package:flexivity/data/models/friendship_status.dart';

class SendFriendRequest {
  final int userId;
  final String friendUserName;
  final FriendshipStatus status;

  SendFriendRequest(this.userId, this.friendUserName, this.status);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'friendUserName': friendUserName,
      'status': status.toJson(),
    };
  }
}
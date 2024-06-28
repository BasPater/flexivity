class DeleteFriendRequest {
  final int userId;
  final int friendId;

  DeleteFriendRequest(this.userId, this.friendId);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'friendId': friendId,
    };
  }
}
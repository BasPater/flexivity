enum FriendshipStatus { pending, accepted, rejected, blocked }

extension FriendshipStatusFromJsonExtension on FriendshipStatus {
  static FriendshipStatus fromJson(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return FriendshipStatus.accepted;
      case 'rejected':
        return FriendshipStatus.rejected;
      case 'blocked':
        return FriendshipStatus.blocked;
      case 'pending':
      default:
        return FriendshipStatus.pending;
    }
  }
}

extension FriendshipStatusToJsonExtension on FriendshipStatus {
  String toJson() {
    switch (this) {
      case FriendshipStatus.accepted:
        return 'ACCEPTED';
      case FriendshipStatus.rejected:
        return 'REJECTED';
      case FriendshipStatus.blocked:
        return 'BLOCKED';
      case FriendshipStatus.pending:
        return 'PENDING';
      default:
        return 'PENDING';
    }
  }
}

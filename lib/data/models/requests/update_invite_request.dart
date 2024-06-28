class UpdateInviteRequest {
  num groupId;
  String status;

  UpdateInviteRequest({
    required this.groupId,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'groupId': this.groupId,
    'status': this.status,
  };

}
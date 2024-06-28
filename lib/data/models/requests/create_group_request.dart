class CreateGroupRequest {
  final String groupName;
  final List<int> members;

  CreateGroupRequest({required this.groupName, required this.members});

  factory CreateGroupRequest.fromJson(Map<String, dynamic> json) {
    return CreateGroupRequest(
      groupName: json['groupName'],
      members: List.from(json['members'].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'members': List.from(members.map((x) => x)),
    };
  }
}
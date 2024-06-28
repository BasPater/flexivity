class GetGroupWithActivityAtDateRequest {
  final int groupId;
  final DateTime date;

  GetGroupWithActivityAtDateRequest({
    required this.groupId,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'date': date.toIso8601String(),
    };
  }
}
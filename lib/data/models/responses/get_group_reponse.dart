import 'package:flexivity/data/models/user.dart';

class GetGroupResponse {
  final int groupId;
  final String groupName;
  final User ownedBy;
  final int userPosition;
  final User nr1;

  GetGroupResponse(
      this.groupId, this.groupName, this.ownedBy, this.userPosition, this.nr1);

  factory GetGroupResponse.fromJson(Map<String, dynamic> json) {
    return GetGroupResponse(
      json['groupId'],
      json['groupName'],
      User.fromJson(json['ownedBy']),
      json['userPosition'],
      User.fromJson(json['nr1']),
    );
  }

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'groupName': groupName,
        'ownedBy': ownedBy.toJson(),
        'userPosition': userPosition,
        'nr1': nr1.toJson(),
      };
}

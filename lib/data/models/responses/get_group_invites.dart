import 'package:flexivity/data/models/basic_group.dart';

import '../user.dart';

class GetGroupInvitesResponse {
  final BasicGroup group;
  final User invitedBy;

  GetGroupInvitesResponse(this.group, this.invitedBy);

  factory GetGroupInvitesResponse.fromJson(Map<String, dynamic> json) {
    return GetGroupInvitesResponse(
      BasicGroup.fromJson(json['group']),
      User.fromJson(json['invitedBy']),
    );
  }

  Map<String, dynamic> toJson() => {
    'group': group.toJson(),
    'invitedBy': invitedBy.toJson(),
  };


}
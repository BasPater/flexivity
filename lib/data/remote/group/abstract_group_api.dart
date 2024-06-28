import 'package:flexivity/data/models/requests/create_group_request.dart';
import 'package:flexivity/data/models/responses/get_group_reponse.dart';

import '../../models/requests/get_group_with_activity_at_date_request.dart';
import '../../models/requests/update_invite_request.dart';
import '../../models/responses/get_group_invites.dart';
import '../../models/responses/get_group_with_activity_at_date_response.dart';

abstract interface class IGroupApi {
  Future<bool> createGroup(CreateGroupRequest request);
  Future<List<GetGroupResponse>> getGroups();
  Future<bool> deleteGroup(int groupId);
  Future<bool> updateInvite(UpdateInviteRequest request);
  Future<GetGroupWithActivityAtDateResponse> getGroupWithActivityAtDate(GetGroupWithActivityAtDateRequest request);
  Future<List<GetGroupInvitesResponse>> getGroupInvites();
  Future<bool> leaveGroup(int groupId);
  Future<bool> inviteGroupMembers(int groupId, List<int> userIds);
  Future<bool> deleteGroupMember(int groupId, int userId);
  Future<bool> changeRole(int groupId, int userId, String role);
}
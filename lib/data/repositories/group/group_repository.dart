import 'package:flexivity/data/models/requests/update_invite_request.dart';
import 'package:flexivity/data/models/responses/get_group_reponse.dart';
import 'package:flexivity/data/models/responses/get_group_with_activity_at_date_response.dart';
import 'package:flexivity/data/remote/group/group_api.dart';
import 'package:flexivity/domain/repositories/group_repository/abstract_group_repository.dart';

import '../../models/requests/create_group_request.dart';
import '../../models/requests/get_group_with_activity_at_date_request.dart';
import '../../models/responses/get_group_invites.dart';

class GroupRepository implements IGroupRepository {
  final GroupApi api;
  GroupRepository(this.api);

  @override
  Future<bool> createGroup(CreateGroupRequest request) {
    return api.createGroup(request);
  }

  @override
  Future<List<GetGroupResponse>> getGroups() {
    return api.getGroups();
  }

  @override
  Future<bool> deleteGroup(int groupId) {
    return api.deleteGroup(groupId);
  }

  @override
  Future<bool> updateInvite(UpdateInviteRequest request) {
    return api.updateInvite(request);
  }

  @override
  Future<GetGroupWithActivityAtDateResponse> getGroupWithActivityAtDate(GetGroupWithActivityAtDateRequest request) {
    return api.getGroupWithActivityAtDate(request);
  }

  @override
  Future<List<GetGroupInvitesResponse>> getGroupInvites() {
    return api.getGroupInvites();
  }

  @override
  Future<bool> leaveGroup(int groupId) {
    return api.leaveGroup(groupId);
  }

  @override
  Future<bool> changeRole(int groupId, int userId, String role) {
    return api.changeRole(groupId, userId, role);
  }

  @override
  Future<bool> deleteGroupMember(int groupId, int userId) {
    return api.deleteGroupMember(groupId, userId);
  }

  @override
  Future<bool> inviteGroupMembers(int groupId, List<int> userIds) {
    return api.inviteGroupMembers(groupId, userIds);
  }




}
import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/requests/create_group_request.dart';
import 'package:flexivity/data/models/requests/get_group_with_activity_at_date_request.dart';
import 'package:flexivity/data/models/requests/update_invite_request.dart';
import 'package:flexivity/data/models/responses/get_group_invites.dart';
import 'package:flexivity/data/models/responses/get_group_reponse.dart';
import 'package:flexivity/data/models/responses/get_group_with_activity_at_date_response.dart';
import 'package:flexivity/data/remote/base/http_api.dart';
import 'package:flexivity/data/remote/group/abstract_group_api.dart';
import 'package:http/http.dart';

class GroupApi extends HttpApi implements IGroupApi {
  GroupApi(super.client, super.credentials);

  @override
  Future<bool> createGroup(CreateGroupRequest request) async {
    Response response = await super.post(
      'api/v1/group',
      body: request,
    );
    // Check if the request succeeded
    return response.statusCode == HttpStatus.ok;
  }

  @override
  Future<List<GetGroupResponse>> getGroups() async {
    Response response = await super.get(
      'api/v1/group',
    );

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(ApiException(
        'Error retrieving groups, status: ${response.statusCode}.',
      ));
    }

    // Decode the response body
    var jsonResponse = jsonDecode(response.body);

    // Map each item in the JSON response to a GetGroupResponse object
    List<GetGroupResponse> groupResponses = (jsonResponse as List)
        .map((item) => GetGroupResponse.fromJson(item))
        .toList();

    return groupResponses;
  }

  @override
  Future<bool> deleteGroup(int groupId) async {
    Response response = await super.delete(
      'api/v1/group',
      body: {'groupId': groupId},
    );

    return response.statusCode == HttpStatus.ok;
  }

  @override
  Future<bool> updateInvite(UpdateInviteRequest request) async {
    Response response = await super.put(
      'api/v1/group/member',
      body: request,
    );

    return response.statusCode == HttpStatus.ok;
  }

  @override
  Future<GetGroupWithActivityAtDateResponse> getGroupWithActivityAtDate(GetGroupWithActivityAtDateRequest request) async {
    Response response = await super.get(
      'api/v1/group/${request.groupId}?date=${request.date.toString().split(' ')[0]}',
    );
    if (response.statusCode != HttpStatus.ok) {
      return Future.error(ApiException(
        'Error retrieving group with activity at date, status: ${response.statusCode}.',
      ));
    }

    // Decode the response body
    var jsonResponse = jsonDecode(response.body);

    return GetGroupWithActivityAtDateResponse.fromJson(jsonResponse);
  }

  @override
  Future<List<GetGroupInvitesResponse>> getGroupInvites() async {
    Response response = await super.get(
      'api/v1/group/member/invites',
    );

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(ApiException(
        'Error retrieving group invites, status: ${response.statusCode}.',
      ));
    }

    // Decode the response body
    var jsonResponse = jsonDecode(response.body);

    // Map each item in the JSON response to a GetGroupInvitesResponse object
    List<GetGroupInvitesResponse> inviteResponses = (jsonResponse as List)
        .map((item) => GetGroupInvitesResponse.fromJson(item))
        .toList();

    return inviteResponses;
  }

  @override
  Future<bool> leaveGroup(int groupId) async {
    Response response = await super.delete(
      'api/v1/group/member/leave',
      body: {'groupId': groupId},
    );

    return response.statusCode == HttpStatus.ok;
  }

  @override
  Future<bool> changeRole(int groupId, int userId, String role) async {
    Response response = await super.put(
      'api/v1/group/member/role',
      body: {'groupId': groupId, 'userId': userId, 'role': role},
    );

    return response.statusCode == HttpStatus.ok;
  }

  @override
  Future<bool> deleteGroupMember(int groupId, int userId) async {
    try {
      Response response = await super.delete(
        'api/v1/group/member',
        body: {'groupId': groupId, 'removeUserId': userId},
      );

      return response.statusCode == HttpStatus.ok;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> inviteGroupMembers(int groupId, List<int> userIds) async {
    Response response = await super.post(
      'api/v1/group/member',
      body: {'groupId': groupId, 'userIds': userIds},
    );

    return response.statusCode == HttpStatus.ok;
  }
}
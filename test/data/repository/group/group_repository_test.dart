import 'package:flexivity/data/models/basic_group.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/member.dart';
import 'package:flexivity/data/models/requests/create_group_request.dart';
import 'package:flexivity/data/models/requests/get_group_with_activity_at_date_request.dart';
import 'package:flexivity/data/models/requests/update_invite_request.dart';
import 'package:flexivity/data/models/responses/get_group_invites.dart';
import 'package:flexivity/data/models/responses/get_group_reponse.dart';
import 'package:flexivity/data/models/responses/get_group_with_activity_at_date_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/remote/group/group_api.dart';
import 'package:flexivity/data/repositories/group/group_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'group_repository_test.mocks.dart';

GetGroupResponse createTestGetGroupResponse() {
  User ownedBy = User(2, 'test@test.com', 'testuser', 'Test', 'User', 'ADMIN');
  User nr1 = User(3, 'nr1@test.com', 'nr1user', 'Nr1', 'User', 'USER');
  GetGroupResponse response = GetGroupResponse(1, 'Test Group', ownedBy, 1, nr1);
  return response;
}

GetGroupWithActivityAtDateResponse createTestGetGroupWithActivityAtDateResponse() {
  User user = User(1, 'test@test.com', 'testuser', 'Test', 'User', 'USER');
  User user2 = User(2, 'test@test.com', 'testuser', 'Test', 'User', 'USER');
  BasicActivity activity = BasicActivity(100, 200);
  BasicActivity activity2 = BasicActivity(150, 250);
  BasicGroup group = BasicGroup(1, 'Test Group', user);
  Member member = Member(user, activity);
  Member member2 = Member(user2, activity2);
  GetGroupWithActivityAtDateResponse response = GetGroupWithActivityAtDateResponse(
      group,
      [member2, member]
  );

  return response;
}

List<GetGroupInvitesResponse> createTestGetGroupInvitesResponse() {

  User user = User(1, 'test@test.com', 'testuser', 'Test', 'User', 'USER');

  BasicGroup group1 = BasicGroup(1, 'test group 1', user);
  BasicGroup group2 = BasicGroup(2, 'test group 2', user);


  GetGroupInvitesResponse getGroupInvitesResponse1 = GetGroupInvitesResponse(group1, user);
  GetGroupInvitesResponse getGroupInvitesResponse2 = GetGroupInvitesResponse(group2, user);

  List<GetGroupInvitesResponse> response = [getGroupInvitesResponse1, getGroupInvitesResponse2];

  return response;
}

@GenerateNiceMocks([MockSpec<GroupApi>()])
void main() {
  late MockGroupApi mockGroupApi;
  late GroupRepository groupRepository;

  setUp(() {
     mockGroupApi = MockGroupApi();
    groupRepository = GroupRepository(mockGroupApi);
  });
  group('GroupRepository', () {

    test('getGroups calls api.getGroups', () {
      var response = [createTestGetGroupResponse()];

      when(mockGroupApi.getGroups()).thenAnswer((_) async => response);

      expectLater(groupRepository.getGroups(), completion(response));
    });

    test('createGroup calls api.createGroup and returns true', () {
      var request = CreateGroupRequest(groupName: "Test", members: [1, 2 , 4]);

      when(mockGroupApi.createGroup(any)).thenAnswer((_) async => true);

      expectLater(groupRepository.createGroup(request), completion(true));
    });

    test('createGroup calls api.createGroup and returns false', () {
      var request = CreateGroupRequest(groupName: "Test", members: [1, 2 , 4]);

      when(mockGroupApi.createGroup(any)).thenAnswer((_) async => false);

      expectLater(groupRepository.createGroup(request), completion(false));
    });
  });

  group('deleteGroup', (){
    test('deleteGroup calls api.deleteGroup and returns true', () {
      var groupId = 1;

      when(mockGroupApi.deleteGroup(any)).thenAnswer((_) async => true);

      expectLater(groupRepository.deleteGroup(groupId), completion(true));
    });

    test('deleteGroup calls api.deleteGroup and returns false', () {
      var groupId = 1;

      when(mockGroupApi.deleteGroup(any)).thenAnswer((_) async => false);

      expectLater(groupRepository.deleteGroup(groupId), completion(false));
    });
  });

  group('updateInvite', (){
    test('updateInvite calls api.updateInvite and returns true', () {
      var request = UpdateInviteRequest(groupId: 1, status: 'ACCEPTED');

      when(mockGroupApi.updateInvite(request)).thenAnswer((_) async => true);

      expectLater(groupRepository.updateInvite(request), completion(true));
    });

    test('updateInvite calls api.updateInvite and returns false', () {
      var request = UpdateInviteRequest(groupId: 1, status: 'ACCEPTED');

      when(mockGroupApi.updateInvite(request)).thenAnswer((_) async => false);

      expectLater(groupRepository.updateInvite(request), completion(false));
    });
  });

  group('getGroupWithActivityAtDate', (){
    test('getGroupWithActivityAtDate calls api.getGroupWithActivityAtDate', () {
      var request = GetGroupWithActivityAtDateRequest(groupId: 1, date: DateTime.now());
      var response = createTestGetGroupWithActivityAtDateResponse();

      when(mockGroupApi.getGroupWithActivityAtDate(any)).thenAnswer((_) async => response);

      expectLater(groupRepository.getGroupWithActivityAtDate(request), completion(response));
    });

    test('getGroupWithActivityAtDate calls api.getGroupWithActivityAtDate and throws ApiException', () {
      var request = GetGroupWithActivityAtDateRequest(groupId: 1, date: DateTime.now());

      when(mockGroupApi.getGroupWithActivityAtDate(any)).thenAnswer((_) async => throw ApiException('Error retrieving group with activity at date, status: 404.'));

      expectLater(groupRepository.getGroupWithActivityAtDate(request), throwsA(isA<ApiException>()));
    });
  });

  group('getGroupInvites', (){
    test('getGroupInvites calls api.getGroupInvites', () {
      var response = createTestGetGroupInvitesResponse();

      when(mockGroupApi.getGroupInvites()).thenAnswer((_) async => response);

      expectLater(groupRepository.getGroupInvites(), completion(response));
    });

    test('getGroupInvites calls api.getGroupInvites and throws ApiException', () {
      when(mockGroupApi.getGroupInvites()).thenAnswer((_) async => throw ApiException('Error retrieving group invites, status: 404.'));

      expectLater(groupRepository.getGroupInvites(), throwsA(isA<ApiException>()));
    });
  });

  group('leave group', (){
    test('returns true when the call completes successfully', () async {
      when(mockGroupApi.leaveGroup(any)).thenAnswer(
            (_) async => true,
      );

      expect(await groupRepository.leaveGroup(1), true);
    });

    test('returns false when the call does not completes successfully', () async {
      when(mockGroupApi.leaveGroup(any)).thenAnswer((_) async => false);

      expect(await groupRepository.leaveGroup(1), false);
    });
  });

  group('changeRole', () {
    test('returns true when the call completes successfully', () async {
      when(mockGroupApi.changeRole(any, any, any)).thenAnswer(
            (_) async => true,
      );

      expect(await groupRepository.changeRole(1, 1, 'ADMIN'), true);
    });

    test('returns false when the call does not completes successfully', () async {
      when(mockGroupApi.changeRole(any, any, any)).thenAnswer((_) async => false);

      expect(await groupRepository.changeRole(1, 1, 'ADMIN'), false);
    });
  });

  group('deleteGroupMember', () {
    test('returns true when the call completes successfully', () async {
      when(mockGroupApi.deleteGroupMember(any, any)).thenAnswer(
            (_) async => true,
      );

      expect(await groupRepository.deleteGroupMember(1, 1), true);
    });

    test('returns false when the call does not completes successfully', () async {
      when(mockGroupApi.deleteGroupMember(any, any)).thenAnswer((_) async => false);

      expect(await groupRepository.deleteGroupMember(1, 1), false);
    });
  });

  group('inviteGroupMembers', () {
    test('returns true when the call completes successfully', () async {
      when(mockGroupApi.inviteGroupMembers(any, any)).thenAnswer(
            (_) async => true,
      );

      expect(await groupRepository.inviteGroupMembers(1, [1, 2, 3]), true);
    });

    test('returns false when the call does not completes successfully', () async {
      when(mockGroupApi.inviteGroupMembers(any, any)).thenAnswer((_) async => false);

      expect(await groupRepository.inviteGroupMembers(1, [1, 2, 3]), false);
    });
  });
}
import 'package:flexivity/data/models/basic_group.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/member.dart';
import 'package:flexivity/data/models/requests/create_group_request.dart';
import 'package:flexivity/data/models/requests/get_group_with_activity_at_date_request.dart';
import 'package:flexivity/data/models/requests/update_invite_request.dart';
import 'package:flexivity/data/models/responses/error_response.dart';
import 'package:flexivity/data/models/responses/get_group_invites.dart';
import 'package:flexivity/data/models/responses/get_group_reponse.dart';
import 'package:flexivity/data/models/responses/get_group_with_activity_at_date_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/remote/group/group_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../authentication/web_authentication_api_test.dart';
import '../friend/friend_api_test.mocks.dart';

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


@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  MockClient mockClient = MockClient();
  const testCredentials = Credentials(1, 'token', 'token');
  GroupApi groupApi = GroupApi(mockClient, testCredentials);
  dotenv.testLoad();

  setUp(() {
    reset(mockClient);
  });




    group('createGroup', () {
      test('returns true when the call completes successfully', () async {
        CreateGroupRequest request =
            CreateGroupRequest(groupName: "Test", members: [1, 2, 17]);

        when(mockClient.send(any)).thenAnswer(
          (_) async => StreamedResponse(Stream.empty(), 200),
        );

        expect(await groupApi.createGroup(request), true);
      });

      test('returns true when the call does not completes successfully', () async {
        CreateGroupRequest request =
        CreateGroupRequest(groupName: "Test", members: [1, 2, 17]);

        when(mockClient.send(any)).thenAnswer(
              (_) async => StreamedResponse(Stream.empty(), 400),
        );

        expect(await groupApi.createGroup(request), false);
      });
    });

  group('getGroup', () {
    test('returns true when the call completes successfully', () async {
      var response = [createTestGetGroupResponse()];

      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(toUtf8Stream(response), 200),
      );

      var getGroupsResponse = await groupApi.getGroups();

      expect(getGroupsResponse.length, response.length);
      expect(getGroupsResponse[0].groupName, response[0].groupName);
    });

    test('throws an exception when the status code is not 200', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('', '', DateTime.now())),
          404,
        ),
      );

      expectLater(groupApi.getGroups(), throwsA(isA<ApiException>()));
    });
  });

  group('deleteGroup', (){
    test('returns true when the call completes successfully', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 200),
      );

      expect(await groupApi.deleteGroup(1), true);
    });

    test('returns false when the call does not completes successfully', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(toUtf8Stream(ErrorResponse('', '', DateTime.now())),
              404,
            )
      );

      expect(await groupApi.deleteGroup(1), false);
    });
  });

  group('updateInvite', (){
    test('returns true when the call completes successfully', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 200),
      );

      expect(await groupApi.updateInvite(UpdateInviteRequest(groupId: 1, status: "ACCEPTED")), true);
    });

    test('returns false when the call does not completes successfully', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 404),
      );

      expect(await groupApi.updateInvite(UpdateInviteRequest(groupId: 1, status: "ACCEPTED")), false);
    });
  });

  group('GetGroupWithActivityAtDateResponse', (){
    test('returns GetGroupWithActivityAtDateResponse when the call completes successfully', () async {
      var response = createTestGetGroupWithActivityAtDateResponse();

      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(toUtf8Stream(response), 200),
      );

      var getGroupWithActivityAtDateResponse = await groupApi.getGroupWithActivityAtDate(GetGroupWithActivityAtDateRequest(groupId: 1, date: DateTime.now()));

      expect(getGroupWithActivityAtDateResponse.group.name, response.group.name);
      expect(getGroupWithActivityAtDateResponse.members.length, response.members.length);
    });

    test('throws an exception when the status code is not 200', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('', '', DateTime.now())),
          404,
        ),
      );

      expectLater(groupApi.getGroupWithActivityAtDate(GetGroupWithActivityAtDateRequest(groupId: 1, date: DateTime.now())), throwsA(isA<ApiException>()));
    });
  });

  group('getGroupInvites', (){
    test('returns GetGroupInvitesResponse when the call completes successfully', () async {
      var response = createTestGetGroupInvitesResponse();

      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(toUtf8Stream(response), 200),
      );

      var getGroupInvitesResponse = await groupApi.getGroupInvites();

      expect(getGroupInvitesResponse.length, response.length);
    });

    test('throws an exception when the status code is not 200', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('', '', DateTime.now())),
          404,
        ),
      );

      expectLater(groupApi.getGroupInvites(), throwsA(isA<ApiException>()));
    });
  });

  group('leaveGroup', (){
    test('returns true when leaveGroup is successful ', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 200),
      );

      expect(await groupApi.leaveGroup(1), true);
    });

    test('returns true when leaveGroup is successful ', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 400),
      );

      expect(await groupApi.leaveGroup(1), false);
    });
  });

  group('changeRole', () {
    test('returns true when changeRole is successful ', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 200),
      );

      expect(await groupApi.changeRole(1, 1, 'ADMIN'), true);
    });

    test('returns false when changeRole is unsuccessful ', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 400),
      );

      expect(await groupApi.changeRole(1, 1, 'ADMIN'), false);
    });
  });

  group('deleteGroupMember', () {
    test('returns true when deleteGroupMember is successful ', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 200),
      );

      expect(await groupApi.deleteGroupMember(1, 1), true);
    });

    test('returns false when deleteGroupMember is unsuccessful ', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 403),
      );

      expect(await groupApi.deleteGroupMember(1, 1), false);
    });
  });

  group('inviteGroupMember', () {
    test('returns true when inviteGroupMember is successful ', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 200),
      );

      expect(await groupApi.inviteGroupMembers(1, [1]), true);
    });

    test('returns false when inviteGroupMember is umsuccessful ', () async {
      when(mockClient.send(any)).thenAnswer(
            (_) async => StreamedResponse(Stream.empty(), 400),
      );

      expect(await groupApi.inviteGroupMembers(1, [1]), false);
    });
  });
}

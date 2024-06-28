import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/models/day_activity.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friend.dart';
import 'package:flexivity/data/models/friend_request.dart';
import 'package:flexivity/data/models/friendship.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/requests/delete_friend_request.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/requests/response_friendship_request.dart';
import 'package:flexivity/data/models/requests/send_friend_request.dart';
import 'package:flexivity/data/models/responses/get_friend_request_response.dart';
import 'package:flexivity/data/models/responses/error_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/remote/friend/friend_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'friend_api_test.mocks.dart';

Friend testFriend1 = Friend(
    1,
    // userId
    'friend1@email.com',
    // email
    'testFriend1',
    // userName
    'Friend1',
    // firstName
    'One',
    // lastName
    'friend',
    // role
    DayActivity(1000, 200) // activity
    );

Friend testFriend2 = Friend(
    2,
    // userId
    'friend2@email.com',
    // email
    'testFriend2',
    // userName
    'Friend2',
    // firstName
    'Two',
    // lastName
    'friend',
    // role
    DayActivity(2000, 300) // activity
    );

Friendship testFriendship1 = Friendship(
    1, // friendshipId
    testFriend1, // friend
    FriendshipStatus.accepted, // status
    1, // actionUserId
    DateTime.now(), // createdAt
    DateTime.now() // updatedAt
    );

User testUser = User(
    1, // userId
    'testuser@email.com', // email
    'testUser', // userName
    'Test', // firstName
    'User', // lastName
    'USER' // role
    );

Friendship testFriendship2 = Friendship(
    2, // friendshipId
    testFriend2, // friend
    FriendshipStatus.pending, // status
    2, // actionUserId
    DateTime.now(), // createdAt
    DateTime.now() // updatedAt
    );

FriendRequest testGetFriendRequestResponse = FriendRequest(
  friendshipId: 1,
  friend: testUser,
  status: FriendshipStatus.pending,
  actionUserId: 1,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

Stream<List<int>> toUtf8Stream(Object obj) {
  return Stream.value(utf8.encode(jsonEncode(obj)));
}

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  MockClient mockClient = MockClient();
  const testCredentials = Credentials(1, 'token', 'token');
  FriendApi friendApi = FriendApi(mockClient, testCredentials);
  dotenv.testLoad();

  setUp(() {
    reset(mockClient);
  });

  group('FriendApi', () {
    group('deleteFriend', () {
      test('returns true when the call completes successfully', () async {
        when(mockClient.send(any)).thenAnswer(
          (_) async => StreamedResponse(Stream.empty(), 200),
        );

        expect(await friendApi.deleteFriend(DeleteFriendRequest(1, 1)), true);
      });
    });
  });

  group('getFriends', () {
    test(
      'returns GetFriendshipResponse when the call completes successfully',
      () async {
        when(mockClient.send(any)).thenAnswer(
          (_) async => StreamedResponse(toUtf8Stream([testFriendship1]), 200),
        );

        var result = await friendApi.getFriends(1);

        verify(mockClient.send(any));
        expect(result.list[0].friend.userId, 1);
        expect(result.list[0].friend.firstName, 'Friend1');
      },
    );

    test('throws an exception when there is a network error', () async {
      when(mockClient.send(any))
          .thenThrow(const SocketException('Failed to get friends'));

      expectLater(friendApi.getFriends(1), throwsA(isA<ApiException>()));
    });

    test('throws an exception when the status code is not 200', () async {
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('', '', DateTime.now())),
          404,
        ),
      );

      expectLater(friendApi.getFriends(1), throwsA(isA<ApiException>()));
    });
  });


  group('friendApi.addFriend', () {
    test('friendApi.addFriend should throw error', () async {
      when(mockClient.send(any))
          .thenThrow(const SocketException('Failed to get friends'));

      final SendFriendRequest sendFriendRequest =
          SendFriendRequest(1, "cheese", FriendshipStatus.pending);

      expectLater(
        friendApi.addFriend(sendFriendRequest),
        throwsA(isA<ApiException>()),
      );
    });

    test('friendApi.addFriend should return false', () async {
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('Not Found', '', DateTime.now())),
          404,
        ),
      );
      final SendFriendRequest sendFriendRequest =
          SendFriendRequest(1, "cheese", FriendshipStatus.pending);

      var result = await friendApi.addFriend(sendFriendRequest);

      expect(result, false);
    });

    test('friendApi.addFriend should throw error', () async {
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          Stream.empty(),
          200,
        ),
      );
      final SendFriendRequest sendFriendRequest =
          SendFriendRequest(1, "cheese", FriendshipStatus.pending);

      var result = await friendApi.addFriend(sendFriendRequest);

      expect(result, true);
    });
  });

  group('friendApi.respondFriendRequest', () {
    test('friendApi.respondFriendRequest should return true', () async {
      when(mockClient.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 200));
      final ResponseFriendshipRequest sendFriendRequest =
          ResponseFriendshipRequest(1, 2, FriendshipStatus.accepted);

      var result = await friendApi.respondFriendRequest(sendFriendRequest);

      expectLater(result, true);
    });

    test('friendApi.respondFriendRequest should return false', () async {
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('Error', '', DateTime.now())),
          400,
        ),
      );
      final ResponseFriendshipRequest sendFriendRequest =
          ResponseFriendshipRequest(1, 2, FriendshipStatus.accepted);

      var result = await friendApi.respondFriendRequest(sendFriendRequest);

      expectLater(result, false);
    });
  });

  group('friendApi.getFriendRequests', () {
    test('friendApi.getFriendRequests should return response', () async {
      final GetFriendRequestResponse getFriendRequestResponse =
          GetFriendRequestResponse([testGetFriendRequestResponse]);

      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(getFriendRequestResponse),
          200,
        ),
      );

      var result = await friendApi.getFriendRequests(1);

      expectLater(result.list[0].friend.userId,
          getFriendRequestResponse.list[0].friend.userId);

      reset(mockClient);
    });

    test('friendApi.getFriendRequests should return ApiException', () async {
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('Added', '', DateTime.now())),
          400,
        ),
      );

      expectLater(friendApi.getFriendRequests(1), throwsA(isA<ApiException>()));
      reset(mockClient);
    });
  });
}

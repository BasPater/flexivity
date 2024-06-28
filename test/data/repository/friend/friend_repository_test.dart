import 'package:flexivity/data/models/day_activity.dart';
import 'package:flexivity/data/models/friend.dart';
import 'package:flexivity/data/models/friend_request.dart';
import 'package:flexivity/data/models/friendship.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/requests/delete_friend_request.dart';
import 'package:flexivity/data/models/requests/response_friendship_request.dart';
import 'package:flexivity/data/models/requests/send_friend_request.dart';
import 'package:flexivity/data/models/responses/get_friend_request_response.dart';
import 'package:flexivity/data/models/responses/get_friendships_response.dart';
import 'package:flexivity/data/remote/friend/friend_api.dart';
import 'package:flexivity/data/repositories/friend/friend_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'friend_repository_test.mocks.dart';

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
  friend: testFriend1,
  status: FriendshipStatus.pending,
  actionUserId: 1,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

@GenerateNiceMocks([MockSpec<FriendApi>()])
void main() {
  group('FriendRepository', () {
    MockFriendApi mockFriendApi = MockFriendApi();
    FriendRepository friendRepository = FriendRepository(mockFriendApi);

    test('addFriend calls api.addFriend', () {
      when(mockFriendApi.addFriend(any)).thenAnswer((_) async => true);

      SendFriendRequest request =
          SendFriendRequest(1, "kaas", FriendshipStatus.pending);

      expectLater(friendRepository.addFriend(request), completion(true));
    });

    test('deleteFriend calls api.deleteFriend with correct request', () {
      var request = DeleteFriendRequest(1, 1);
      when(mockFriendApi.deleteFriend(request)).thenAnswer((_) async => true);

      expectLater(friendRepository.deleteFriend(request), completion(true));
    });

    test('getFriends calls api.getFriends with correct id', () {
      const id = 1;
      final response =
          GetFriendshipResponse([testFriendship1, testFriendship2]);
      when(mockFriendApi.getFriends(id)).thenAnswer((_) async => response);

      expectLater(friendRepository.getFriends(id), completion(response));
    });

    test('getFriendRequests calls api.getFriendRequests with correct id', () {
      const id = 1;
      final response = GetFriendRequestResponse([testGetFriendRequestResponse]);
      when(mockFriendApi.getFriendRequests(id))
          .thenAnswer((_) async => response);

      expectLater(friendRepository.getFriendRequests(id), completion(response));
    });

    test(
        'respondFriendRequest calls api.respondFriendRequest with correct request',
        () {
      final request =
          ResponseFriendshipRequest(1, 2, FriendshipStatus.accepted);
      when(mockFriendApi.respondFriendRequest(request))
          .thenAnswer((_) async => true);

      expectLater(
          friendRepository.respondFriendRequest(request), completion(true));
    });
  });
}

import 'package:flexivity/data/models/requests/delete_friend_request.dart';
import 'package:flexivity/data/models/requests/response_friendship_request.dart';
import 'package:flexivity/data/models/responses/get_friend_request_response.dart';
import 'package:flexivity/data/models/requests/send_friend_request.dart';
import 'package:flexivity/data/models/responses/get_friendships_response.dart';

abstract interface class IFriendRepository {
  Future<bool> deleteFriend(DeleteFriendRequest request);
  Future<GetFriendshipResponse> getFriends(int id);
  Future<bool> addFriend(SendFriendRequest request);
  Future<GetFriendRequestResponse> getFriendRequests(int id);
  Future<bool> respondFriendRequest(ResponseFriendshipRequest request);
}
import 'package:flexivity/data/models/requests/delete_friend_request.dart';
import 'package:flexivity/data/models/requests/response_friendship_request.dart';
import 'package:flexivity/data/models/responses/get_friend_request_response.dart';
import 'package:flexivity/data/models/requests/send_friend_request.dart';
import 'package:flexivity/data/models/responses/get_friendships_response.dart';
import 'package:flexivity/data/remote/friend/friend_api.dart';
import 'package:flexivity/domain/repositories/friend/abstract_friend_repository.dart';

class FriendRepository implements IFriendRepository {

  final FriendApi api;

  FriendRepository(this.api);

  @override
  Future<bool> addFriend(SendFriendRequest request) {
    return api.addFriend(request);
  }

  @override
  Future<bool> deleteFriend(DeleteFriendRequest request) {
    return api.deleteFriend(request);
  }

  @override
  Future<GetFriendshipResponse> getFriends(int id) {
    return api.getFriends(id);
  }

  @override
  Future<GetFriendRequestResponse> getFriendRequests(int id) {
    return api.getFriendRequests(id);
  }

  @override
  Future<bool> respondFriendRequest(ResponseFriendshipRequest request) {
    return api.respondFriendRequest(request);
  }

}
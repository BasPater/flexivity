import 'package:flexivity/data/models/friend_request.dart';

class GetFriendRequestResponse {
  final List<FriendRequest> list;

  GetFriendRequestResponse(this.list);

  factory GetFriendRequestResponse.fromJson(List<dynamic> json) {
    List<FriendRequest> friendRequestList = json.map((i) => FriendRequest.fromJson(i)).toList();

    return GetFriendRequestResponse(friendRequestList);
  }

  List<dynamic> toJson() {
    return list.map((friendRequest) => friendRequest.toJson()).toList();
  }
}
import 'package:flexivity/data/models/friendship.dart';

class GetFriendshipResponse {
  final List<Friendship> list;

  GetFriendshipResponse(this.list);

  factory GetFriendshipResponse.fromJson(List<dynamic> json) {
    List<Friendship> friendshipList = json.map((i) => Friendship.fromJson(i)).toList();

    return GetFriendshipResponse(friendshipList);
  }
}
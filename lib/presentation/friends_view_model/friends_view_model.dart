import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/friends_view/friends_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friend.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/domain/repositories/friend/abstract_friend_repository.dart';
import 'package:flutter/material.dart';

import '../../data/models/requests/delete_friend_request.dart';

// ignore: must_be_immutable
class FriendsViewModel extends StatefulWidget {
  final IFriendRepository friendRepo;

  FriendsViewModel({super.key, required this.friendRepo});

  UIState uiState = UIState.loading;
  List<Friend> friendsList = [];
  var index = 0;

  /// Get Friends By ID and set the right UIState
  Future<void> updateFriendList() async {
    try {
      final userId = Globals.credentials?.userId ?? 0;

      final response = await friendRepo.getFriends(userId);

      //Map the response to fill the list
      friendsList = response.list
          .where((item) => item.status == FriendshipStatus.accepted)
          .map((friendship) => friendship.friend)
          .toList();

      //Set UIState to Empty when the list is empty
      if (friendsList.isEmpty) {
        uiState = UIState.empty;
        return;
      }

      // Update friend requests
      await friendRepo.getFriendRequests(userId).then((response) {
        Globals.friendNotificationsCount = response.list.length;
      }).catchError((_) async {
        Globals.friendNotificationsCount = 0;
      });

      uiState = UIState.normal;
    } catch (e) {
      uiState = UIState.error;
    }
  }

  /// Remove friend and set the right UIState
  Future<void> removeFriend(User user) async {
    try {
      bool response = await friendRepo.deleteFriend(
          DeleteFriendRequest(Globals.credentials?.userId ?? 0, user.userId));

      //Set UIState to empty when the list is empty
      if (friendsList.length <= 1) {
        uiState = UIState.empty;
      }

      //When the response returns false the the friend isn't removed so an error should the thrown
      if (!response) {
        return Future.error(
            const ApiException("Something went wrong when removing friends."));
      }
    } on Exception {
      return Future.error(const ApiException(
          "Something is wrong with the connection to the server."));
    }
  }

  @override
  State<FriendsViewModel> createState() => FriendsScreenState();
}

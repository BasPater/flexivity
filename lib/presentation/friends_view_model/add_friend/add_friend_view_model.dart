import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/friends_view/add_friend/add_friend_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/requests/send_friend_request.dart';
import 'package:flexivity/domain/repositories/friend/abstract_friend_repository.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddFriendViewModel extends StatefulWidget {
  final IFriendRepository friendRepo;
  final addFriendController = TextEditingController();
  UIState uiState = UIState.normal;

  AddFriendViewModel({super.key, required this.friendRepo});

  Future addFriend() async {
    try {
      final SendFriendRequest request = SendFriendRequest(Globals.credentials?.userId ?? 0,
          addFriendController.text,
          FriendshipStatus.pending);

      bool result = await friendRepo.addFriend(request);
      uiState = UIState.normal;
      if (result) {
        return null;
      }
      return Future.error(ApiException(
          'Couldn\'t send the friend request because "${request.friendUserName}" isn\'t a valid username.'));
    } catch (e) {
      uiState = UIState.normal;
      return Future.error(const ApiException(
          'Something went wrong when sending the friend request'));
    }
  }

  @override
  State<AddFriendViewModel> createState() => AddFriendScreen();
}

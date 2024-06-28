import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/friends_view/request_view/request_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friend_request.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/requests/response_friendship_request.dart';
import 'package:flexivity/domain/repositories/friend/abstract_friend_repository.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RequestViewModel extends StatefulWidget {
  final IFriendRepository friendRepo;

  RequestViewModel({super.key, required this.friendRepo});

  UIState uiState = UIState.normal;
  List<FriendRequest> requests = [];

  Future getFriendRequests() async {
    try {
      final response =
          await friendRepo.getFriendRequests(Globals.credentials?.userId ?? 0);

      requests = response.list.toList();

      if (requests.isEmpty) {
        uiState = UIState.empty;
        return;
      }
      uiState = UIState.normal;
    } catch (e) {
      uiState = UIState.error;
    }
  }

  Future respondFriendRequest(bool answer, FriendRequest friend) async {
    try {
      await friendRepo.respondFriendRequest(ResponseFriendshipRequest(
          Globals.credentials?.userId ?? 0, friend.friend.userId,
          answer ? FriendshipStatus.accepted : FriendshipStatus.rejected));
      requests.remove(friend);
    } catch (e) {
      throw ApiException('Error updating status of "${friend.friend.userName}"');
    }
  }

  @override
  State<RequestViewModel> createState() => RequestScreen();
}

import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_create/group_create_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friend.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/requests/create_group_request.dart';
import 'package:flexivity/domain/repositories/friend/abstract_friend_repository.dart';
import 'package:flexivity/domain/repositories/group_repository/abstract_group_repository.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GroupCreateViewModel extends StatefulWidget {
  final IFriendRepository friendRepo;
  final IGroupRepository groupRepo;

  GroupCreateViewModel(
      {super.key, required this.friendRepo, required this.groupRepo});

  final groupNameController = TextEditingController();
  UIState uiStateGetFriends = UIState.loading;
  UIState uiStateCreateGroup = UIState.normal;
  List<Friend> friendsList = [];
  List<int> newGroupMemberList = [];

  /// Get Friends By ID and set the right UIState
  Future<void> getFriendsById() async {
    try {
      final response =
          await friendRepo.getFriends(Globals.credentials?.userId ?? 0);

      //Map the response to fill the list
      friendsList = response.list
          .where((item) => item.status == FriendshipStatus.accepted)
          .map((friendship) => friendship.friend)
          .toList();

      //Set UIState to Empty when the list is empty
      if (friendsList.isEmpty) {
        uiStateGetFriends = UIState.empty;
        return;
      }
      uiStateGetFriends = UIState.normal;
    } catch (e) {
      uiStateGetFriends = UIState.error;
    }
  }

  bool updateNewGroupMemberList(int id) {
    if (newGroupMemberList.contains(id)) {
      newGroupMemberList.remove(id);
      return false;
    } else {
      newGroupMemberList.add(id);
      return true;
    }
  }

  Future createGroup() async {
    try {
      bool response = await groupRepo.createGroup(CreateGroupRequest(
          groupName: groupNameController.text, members: newGroupMemberList));

      uiStateCreateGroup = UIState.normal;
      if(!response) {
        throw ApiException("Something went wrong when creating the group.");
      }
    } catch(e) {
      uiStateCreateGroup = UIState.normal;
      throw ApiException("Something went wrong, check your internet connection.");
    }
  }

  @override
  State<GroupCreateViewModel> createState() => GroupCreateScreen();
}

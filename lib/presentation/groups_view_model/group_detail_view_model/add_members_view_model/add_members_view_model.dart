import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_detail/add_members/add_members_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friend.dart';
import 'package:flexivity/data/models/requests/get_group_with_activity_at_date_request.dart';
import 'package:flexivity/data/models/responses/get_group_with_activity_at_date_response.dart';
import 'package:flexivity/domain/repositories/friend/abstract_friend_repository.dart';
import 'package:flexivity/domain/repositories/group_repository/abstract_group_repository.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddMembersViewModel extends StatefulWidget {
  final int groupId;
  final IGroupRepository groupRepo;
  final IFriendRepository friendRepo;

  AddMembersViewModel(
      {super.key,
      required this.groupRepo,
      required this.friendRepo,
      required this.groupId});

  UIState uiState = UIState.loading;
  GetGroupWithActivityAtDateResponse? group = null;
  List<Friend> friendList = [];
  List<Friend> friendListMembersInGroup = [];
  List<int> newMembers = [];

  Future getData() async {
    try {
      group = await groupRepo.getGroupWithActivityAtDate(
          GetGroupWithActivityAtDateRequest(
              groupId: groupId, date: DateTime.now()));

      var response =
          await friendRepo.getFriends(Globals.credentials?.userId ?? 0);

      response.list.forEach((friendship) {
        if (group?.members.any(
                (member) => member.user.userId == friendship.friend.userId) ??
            false) {
          friendListMembersInGroup.add(friendship.friend);
        } else {
          friendList.add(friendship.friend);
        }
        ;
      });

      if (friendList.length == 0) {
        uiState = UIState.empty;
        return;
      }

      uiState = UIState.normal;
    } catch (e) {
      uiState = UIState.error;
    }
  }

  void changeNewMembers(int userId) {
    if (newMembers.contains(userId)) {
      newMembers.remove(userId);
    } else {
      newMembers.add(userId);
    }
  }

  Future addMembers() async {
    try {
       bool response = await groupRepo.inviteGroupMembers(groupId, newMembers);

       if (!response) {
         throw ApiException('Something went wrong while sending the member invites');
       }
       uiState = UIState.normal;
    } catch(e) {
      uiState = UIState.normal;
      throw ApiException('Something went wrong while sending the member invites');
    }
  }

  @override
  State<AddMembersViewModel> createState() => AddMembersScreen();
}

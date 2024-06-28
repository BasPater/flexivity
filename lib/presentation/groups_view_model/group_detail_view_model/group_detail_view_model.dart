import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_detail/group_detail_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/requests/get_group_with_activity_at_date_request.dart';
import 'package:flexivity/data/models/responses/get_group_with_activity_at_date_response.dart';
import 'package:flexivity/domain/repositories/group_repository/abstract_group_repository.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GroupDetailViewModel extends StatefulWidget {
  UIState uiState = UIState.loading;
  final String groupId;
  final String groupName;
  GetGroupWithActivityAtDateResponse? groupToday;
  GetGroupWithActivityAtDateResponse? groupYesterday;
  IGroupRepository groupRepo;
  int userId = 0;
  TextEditingController deleteGroupController = TextEditingController();

  GroupDetailViewModel({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupRepo,
  })  : this.groupToday = null,
        this.groupYesterday = null;

  Future getGroupInformation() async {
    try {
      groupToday = await groupRepo.getGroupWithActivityAtDate(
        GetGroupWithActivityAtDateRequest(
          groupId: int.parse(groupId),
          date: DateTime.now(),
        ),
      );

      userId = Globals.credentials!.userId;

      groupYesterday = await groupRepo.getGroupWithActivityAtDate(
        GetGroupWithActivityAtDateRequest(
          groupId: int.parse(groupId),
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

      uiState = UIState.normal;
    } catch (e) {
      uiState = UIState.error;
    }
  }

  bool isUserModerator(int? userId) {
    if (userId == null || this.userId == 0) {
      return false;
    }

    return groupToday?.members.any((member) =>
            member.user.userId == userId && member.user.role == "MODERATOR") ??
        false;
  }

  bool isUserOwner(int? userId) {
    if (userId == null || this.userId == 0) {
      return false;
    }

    return groupToday?.group.ownedBy.userId == userId;
  }

  Future deleteGroup() async {
    try {
      bool response = await groupRepo.deleteGroup(int.parse(groupId));

      if (!response) {
        throw ApiException('Something went wrong while deleting the group');
      }
    } catch (e) {
      throw ApiException(
          'Something is wrong with the connection to the server.');
    }
  }

  Future leaveGroup() async {
    try {
      bool response = await groupRepo.leaveGroup(int.parse(groupId));

      if (!response) {
        throw ApiException('Something went wrong while leaving the group');
      }
    } catch (e) {
      throw ApiException(
          'Something is wrong with the connection to the server.');
    }
  }

  Future removeUserFromGroup(int userId) async {
    try {
      bool response =
          await groupRepo.deleteGroupMember(int.parse(groupId), userId);

      if (response) {
        groupToday?.members.remove(groupToday?.members.singleWhere((item) => item.user.userId == userId));

        groupYesterday?.members.remove(groupYesterday?.members.singleWhere((item) => item.user.userId == userId));
      } else {
        throw ApiException(
            'Something went wrong while removing the user from the group');
      }
    } catch (e) {
      throw ApiException(
          'Something went wrong while removing the user from the group');
    }
  }

  Future changeRole(int userId, String role) async {
    try {
      bool response =
          await groupRepo.changeRole(int.parse(groupId), userId, role);

      if (response) {
        groupToday?.members.firstWhere((member) => member.user.userId == userId).user.role = role;
      } else {
        throw ApiException('Something went wrong while changes roles');
      }
    } catch (e) {
      throw ApiException(
          'Something went wrong while changes roles');
    }
  }

  @override
  State<GroupDetailViewModel> createState() => GroupDetailScreen();
}

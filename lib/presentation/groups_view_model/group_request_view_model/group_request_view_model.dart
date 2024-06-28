import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_request/group_request_view.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/requests/update_invite_request.dart';
import 'package:flexivity/data/models/responses/get_group_invites.dart';
import 'package:flexivity/domain/repositories/group_repository/abstract_group_repository.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GroupRequestViewModel extends StatefulWidget {
  IGroupRepository groupRepo;

  GroupRequestViewModel({super.key, required this.groupRepo});

  List<GetGroupInvitesResponse> invites = [];
  UIState uiState = UIState.loading;

  Future getGroupInvites() async {
    try {
      invites = await groupRepo.getGroupInvites();
      if (invites.length == 0) {
        uiState = UIState.empty;
      } else {
        uiState = UIState.normal;
      }
    } catch (e) {
      uiState = UIState.error;
      throw ApiException(
          'Something is wrong with the connection to the server.');
    }
  }

  Future updateGroupInvite(bool answer, int groupId) async {
    try {
      bool response = await groupRepo.updateInvite(UpdateInviteRequest(
          groupId: groupId, status: answer ? "ACCEPTED" : "REJECTED",));

      if (response) {
        invites.remove(invites.firstWhere((value) => value.group.groupId == groupId));
      }

      if (invites.length == 0) {
        uiState == UIState.empty;
      }

      if (!response) {
        throw ApiException(
            'Something went wrong when updating your invite status.');
      }
    } catch (e) {
      throw ApiException(
          'Something is wrong with the connection to the server.');
    }
  }

  @override
  State<GroupRequestViewModel> createState() => GroupRequestScreen();
}

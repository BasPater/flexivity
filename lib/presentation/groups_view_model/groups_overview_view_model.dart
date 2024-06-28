import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/groups_view.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/responses/get_group_reponse.dart';
import 'package:flexivity/domain/repositories/group_repository/abstract_group_repository.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GroupOverviewViewModel extends StatefulWidget {
  final IGroupRepository groupRepo;
  List<GetGroupResponse> groups = [];

  GroupOverviewViewModel({super.key, required this.groupRepo});

  UIState uiState = UIState.loading;

  Future<void> updateGroups() async {
    try {
      groups = await groupRepo.getGroups();

      await groupRepo.getGroupInvites().then((invites) {
        Globals.groupNotificationsCount = invites.length;
      }).catchError((_) {
        Globals.groupNotificationsCount = 0;
      });

      if (groups.length == 0) {
        uiState = UIState.empty;
      } else {
        uiState = UIState.normal;
      }
    } catch (e) {
      uiState = UIState.error;
      throw ApiException(
          "Something is wrong with the connection to the server.");
    }
  }

  @override
  State<GroupOverviewViewModel> createState() => GroupOverviewView();
}

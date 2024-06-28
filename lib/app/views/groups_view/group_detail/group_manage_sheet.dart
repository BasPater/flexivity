import 'dart:async';

import 'package:flexivity/app/views/groups_view/group_detail/delete_group_dialog.dart';
import 'package:flexivity/app/views/groups_view/group_detail/leave_group_dialog.dart';
import 'package:flexivity/presentation/groups_view_model/group_detail_view_model/group_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future openManageGroupBottomSheet(BuildContext context,
    GroupDetailViewModel viewModel, Function() setParentState) {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return BottomSheetManageGroup(
        viewModel: viewModel,
        setParentState: setParentState,
      );
    },
  );
}

// ignore: must_be_immutable
class BottomSheetManageGroup extends StatefulWidget {
  GroupDetailViewModel viewModel;
  Function() setParentState;

  BottomSheetManageGroup(
      {super.key, required this.viewModel, required this.setParentState});

  @override
  State<BottomSheetManageGroup> createState() => _BottomSheetManageGroupState();
}

class _BottomSheetManageGroupState extends State<BottomSheetManageGroup> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(
                    height: 32.0,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          widget.viewModel.groupToday?.members.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.account_circle_outlined),
                          title: Text(widget
                                  .viewModel.groupToday?.members[index].user
                                  .getFullname() ??
                              ''),
                          subtitle: Text(
                            '${widget.viewModel.isUserOwner(widget.viewModel.groupToday?.members[index].user.userId) ? "Owner and " : ""}'
                            '${widget.viewModel.isUserModerator(widget.viewModel.groupToday?.members[index].user.userId) ? "Moderator" : "Member"}',
                          ),
                          trailing: (widget.viewModel.isUserModerator(
                                      widget.viewModel.userId) &&
                                  widget.viewModel.groupToday?.members[index]
                                          .user.userId !=
                                      widget.viewModel.userId)
                              ? PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(widget.viewModel.isUserModerator(
                                        widget
                                            .viewModel
                                            .groupToday
                                            ?.members[index]
                                            .user
                                            .userId)
                                        ? Icons.move_down_outlined
                                        : Icons.move_up_outlined),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                        '${widget.viewModel.isUserModerator(widget.viewModel.groupToday?.members[index].user.userId) ? "Demote to Member" : "Promote to Moderator"}'),
                                  ],
                                ),
                                onTap: () async {
                                  try {
                                    await widget.viewModel
                                        .changeRole(
                                        widget
                                            .viewModel
                                            .groupToday
                                            ?.members[index]
                                            .user
                                            .userId ??
                                            0,
                                        widget.viewModel
                                            .isUserModerator(
                                            widget
                                                .viewModel
                                                .groupToday
                                                ?.members[
                                            index]
                                                .user
                                                .userId)
                                            ? "MEMBER"
                                            : "MODERATOR")
                                        .then((_) => setState(() {}));
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Something went wrong while changes roles')));
                                  }
                                },
                              ),
                              if (!widget.viewModel.isUserOwner(widget
                                  .viewModel
                                  .groupToday
                                  ?.members[index]
                                  .user
                                  .userId))
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(Icons.person_remove),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      Text('Remove User from this Group'),
                                    ],
                                  ),
                                  onTap: () async {
                                    await widget.viewModel
                                        .removeUserFromGroup(widget
                                        .viewModel
                                        .groupToday
                                        ?.members[index]
                                        .user
                                        .userId ??
                                        0)
                                        .then((_) {
                                      setState(() {});
                                      widget.setParentState();
                                    });
                                  },
                                ),
                            ],
                          )
                              : null,
                        );
                      }),
                  if (widget.viewModel.groupToday?.group.ownedBy.userId ==
                      widget.viewModel.userId)
                    ListTile(
                      leading: const Icon(Icons.person_add_outlined),
                      title: const Text('Add members'),
                      onTap: () async {
                        context.push('/groups/add/${widget.viewModel.groupId}');
                      },
                    ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Leave group'),
                    onTap: () async {
                      try {
                        if (await showLeaveGroupDialog(context)) {
                          await widget.viewModel.leaveGroup();
                          context.go('/groups');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Something went wrong.')));
                      }
                    },
                  ),
                  if (widget.viewModel.groupToday?.group.ownedBy.userId ==
                      widget.viewModel.userId)
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete group'),
                      onTap: () async {
                        try {
                          if (await showDeleteGroupDialog(
                              context, widget.viewModel)) {
                            await widget.viewModel.deleteGroup();
                            context.go('/groups');
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Something went wrong.')));
                        }
                      },
                    ),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Text(
                      'Manage group',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

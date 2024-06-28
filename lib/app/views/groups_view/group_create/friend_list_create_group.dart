import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/presentation/groups_view_model/group_create_view_model/group_create_view_model.dart';
import 'package:flutter/material.dart';

class FriendListCreateGroup extends StatefulWidget {
  final GroupCreateViewModel viewModel;

  const FriendListCreateGroup({super.key, required this.viewModel});

  @override
  State<FriendListCreateGroup> createState() => _FriendListCreateGroupState();
}

class _FriendListCreateGroupState extends State<FriendListCreateGroup> {
  @override
  Widget build(BuildContext context) {
    return UIStateSwitcher(
      uiState: widget.viewModel.uiStateGetFriends,
      normalState: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.viewModel.friendsList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                setState(() {
                  widget.viewModel.updateNewGroupMemberList(
                      widget.viewModel.friendsList[index].userId);
                });
              },
              leading: Checkbox(
                value: widget.viewModel.newGroupMemberList
                    .contains(widget.viewModel.friendsList[index].userId),
                onChanged: (bool) {
                  setState(() {
                    widget.viewModel.updateNewGroupMemberList(
                        widget.viewModel.friendsList[index].userId);
                  });
                },
              ),
              title: Text(
                  '${widget.viewModel.friendsList[index].firstName} ${widget.viewModel.friendsList[index].lastName}'),
              subtitle: Text(widget.viewModel.friendsList[index].userName),
            );
          }),
      loadingState: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}

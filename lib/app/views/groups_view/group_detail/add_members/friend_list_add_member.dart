import 'package:flexivity/presentation/groups_view_model/group_detail_view_model/add_members_view_model/add_members_view_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FriendListAddMember extends StatefulWidget {
  AddMembersViewModel viewModel;

  FriendListAddMember({super.key, required this.viewModel});

  @override
  State<FriendListAddMember> createState() => _FriendListAddMemberState();
}

class _FriendListAddMemberState extends State<FriendListAddMember> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.viewModel.friendList.length,
        itemBuilder: (BuildContext context, int index) {
          return Material(
            child: ListTile(
              onTap: () {
                setState(() {
                  widget.viewModel.changeNewMembers(
                      widget.viewModel.friendList[index].userId);
                });
              },
              leading: Checkbox(
                value: widget.viewModel.newMembers
                    .contains(widget.viewModel.friendList[index].userId),
                onChanged: (_) {
                  setState(() {
                    widget.viewModel.changeNewMembers(
                        widget.viewModel.friendList[index].userId);
                  });
                },
              ),
              title: Text('${widget.viewModel.friendList[index].getFullname()}'),
            ),
          );
        });
  }
}

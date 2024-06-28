import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_detail/add_members/friend_list_add_member.dart';
import 'package:flexivity/app/views/loading_view/loading_view.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/presentation/groups_view_model/group_detail_view_model/add_members_view_model/add_members_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddMembersScreen extends State<AddMembersViewModel> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future _getData() async {
    await widget.getData().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add members'),
        ),
        body: UIStateSwitcher(
            uiState: widget.uiState,
            normalState: AddMembersContent(
              viewModel: widget,
            ),
            loadingState: LoadingView()));
  }
}

// ignore: must_be_immutable
class AddMembersContent extends StatefulWidget {
  AddMembersViewModel viewModel;

  AddMembersContent({super.key, required this.viewModel});

  @override
  State<AddMembersContent> createState() => _AddMembersContentState();
}

class _AddMembersContentState extends State<AddMembersContent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      '${widget.viewModel.friendListMembersInGroup.map((item) => item.getFullname()).join(', ').toString()} '
                      'are already member(s) of your group.'
                      ' Down below you can invite new members to your group:'),
                ),
                FriendListAddMember(viewModel: widget.viewModel),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                    blurRadius: 7,
                    offset: Offset(0, -3), // changes position of shadow
                  ),
                  BoxShadow(
                    color: Theme.of(context).colorScheme.surface,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: FullWidthButton(
                  isLoading: widget.viewModel.uiState == UIState.loading,
                  label: 'Invite members',
                  onPressed: () async {
                    if (widget.viewModel.newMembers.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Select at least one member to invite to your group.')));
                    } else {
                      try {
                        setState(() {
                          widget.viewModel.uiState == UIState.loading;
                        });
                        await widget.viewModel.addMembers().then((_) {
                          setState(() {});
                          context.pop();
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Something went wrong while sending the invites.')));
                        setState(() {});
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

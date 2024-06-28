import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/empty_view/empty_view.dart';
import 'package:flexivity/app/views/loading_view/loading_view.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/presentation/groups_view_model/group_request_view_model/group_request_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupRequestScreen extends State<GroupRequestViewModel> {
  @override
  void initState() {
    widget.getGroupInvites().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Group invites"),
          leading: IconButton(
            onPressed: () => GoRouter.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: UIStateSwitcher(
          uiState: widget.uiState,
          normalState: GroupRequestContent(
            viewModel: widget,
          ),
          loadingState: LoadingView(),
          emptySate: EmptyView(
            iconData: Icons.mail_outlined,
            text: 'It looks like you don\'t have any group invites.',
            buttonText: 'Refresh',
            onPressed: () async {
              setState(() {
                widget.uiState = UIState.loading;
              });
              await widget.getGroupInvites().then((value) => setState(() {}));
            },
          ),
        ));
  }
}

// ignore: must_be_immutable
class GroupRequestContent extends StatefulWidget {
  GroupRequestViewModel viewModel;

  GroupRequestContent({super.key, required this.viewModel});

  @override
  State<GroupRequestContent> createState() => _GroupRequestContentState();
}

class _GroupRequestContentState extends State<GroupRequestContent> {
  Future updateGroupInvite(bool answer, int groupId) async {
    try {
      await widget.viewModel.updateGroupInvite(answer, groupId).then((_) {
        setState(() {});
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((error as ApiException).message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          return widget.viewModel
              .getGroupInvites()
              .then((value) => setState(() {}));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
              itemCount: widget.viewModel.invites.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.viewModel.invites[index].group.name}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                  'Invited by: ${widget.viewModel.invites[index].invitedBy.firstName} ${widget.viewModel.invites[index].invitedBy.lastName}',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => updateGroupInvite(
                                      true,
                                      widget.viewModel.invites[index].group
                                          .groupId),
                                  icon: Icon(
                                    Icons.check,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                              IconButton(
                                  onPressed: () => updateGroupInvite(
                                      false,
                                      widget.viewModel.invites[index].group
                                          .groupId),
                                  icon: Icon(Icons.close,
                                      color:
                                          Theme.of(context).colorScheme.error)),
                            ],
                          )
                        ],
                      ),
                    )),
                  ),
                );
              }),
        ));
  }
}

import 'package:flexivity/app/helper/get_medal.dart';
import 'package:flexivity/app/views/empty_view/empty_view.dart';
import 'package:flexivity/app/views/loading_view/loading_view.dart';
import 'package:flexivity/app/widgets/navbar_widget.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/presentation/groups_view_model/groups_overview_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;

class GroupOverviewView extends State<GroupOverviewViewModel> {
  @override
  void initState() {
    getGroups();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GroupOverviewViewModel oldWidget) {
    getGroups();
    super.didUpdateWidget(oldWidget);
  }

  Future getGroups() async {
    await widget.updateGroups().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push('/groups/create'),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Groups'),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push('/groups/requests');
            },
            icon: Globals.groupNotificationsCount == 0
                ? Icon(Icons.mail_outlined)
                : badges.Badge(
                    badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
                    position: badges.BadgePosition.topEnd(top: -12, end: -9),
                    badgeContent: Text(
                      Globals.groupNotificationsCount.toString(),
                    ),
                    child: Icon(Icons.mail_outlined),
                  ),
          ),
        ],
      ),
      body: UIStateSwitcher(
        uiState: widget.uiState,
        normalState: GroupOverViewContent(
          viewModel: widget,
          setParent: () => setState(() {}),
          onRefresh: () {
            return getGroups();
          },
        ),
        loadingState: const LoadingView(),
        emptySate: EmptyView(
          iconData: Icons.groups_outlined,
          text: "It looks like you are not part of any groups yet.",
        ),
      ),
      bottomNavigationBar: const NavbarWidget(index: 2),
    );
  }
}

class GroupOverViewContent extends StatefulWidget {
  final GroupOverviewViewModel viewModel;
  final Function() setParent;
  final Future Function() onRefresh;

  const GroupOverViewContent({
    super.key,
    required this.viewModel,
    required this.setParent,
    required this.onRefresh,
  });

  @override
  State<GroupOverViewContent> createState() => _GroupOverViewContentState();
}

class _GroupOverViewContentState extends State<GroupOverViewContent> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return widget.onRefresh();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
            itemCount: widget.viewModel.groups.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      context.push(
                          '/groups/${widget.viewModel.groups[index].groupId}',
                          extra: widget.viewModel.groups[index].groupName);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.viewModel.groups[index].groupName,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                  "Nr 1: ${widget.viewModel.groups[index].nr1.firstName}"
                                  " ${widget.viewModel.groups[index].nr1.lastName}"
                                  " ${widget.viewModel.groups[index].userPosition == 1 ? "(you)" : ""}",
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Your Position:"),
                              Text(
                                getMedal(widget
                                    .viewModel.groups[index].userPosition),
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

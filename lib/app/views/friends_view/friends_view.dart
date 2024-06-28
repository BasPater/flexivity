import 'package:flexivity/app/views/empty_view/empty_view.dart';
import 'package:flexivity/app/views/friends_view/remove_friend_dialog.dart';
import 'package:flexivity/app/views/loading_view/loading_view.dart';
import 'package:flexivity/app/widgets/navbar_widget.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/presentation/friends_view_model/friends_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;

class FriendsScreenState extends State<FriendsViewModel> {
  @override
  void initState() {
    _loadFriends();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FriendsViewModel oldWidget) {
    _loadFriends();
    super.didUpdateWidget(oldWidget);
  }

  Future _loadFriends() async {
    await widget.updateFriendList().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => {GoRouter.of(context).push('/add_friend')},
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Friends'),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push('/friends/request');
            },
            icon: Globals.friendNotificationsCount == 0
                ? Icon(Icons.mail_outlined)
                : badges.Badge(
                    badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
                    position: badges.BadgePosition.topEnd(top: -12, end: -9),
                    badgeContent: Text(
                      Globals.friendNotificationsCount.toString(),
                    ),
                    child: Icon(Icons.mail_outlined),
                  ),
          )
        ],
      ),
      body: UIStateSwitcher(
        uiState: widget.uiState,
        normalState: FriendsContent(
          viewModel: widget,
          setParent: () => setState(() {}),
        ),
        loadingState: const LoadingView(),
        emptySate: EmptyView(
          iconData: Icons.groups_outlined,
          text: "It looks like you haven't added any friends yet.",
        ),
      ),
      bottomNavigationBar: const NavbarWidget(index: 1),
    );
  }
}

class FriendsContent extends StatefulWidget {
  final FriendsViewModel viewModel;
  final Function() setParent;

  const FriendsContent({
    super.key,
    required this.viewModel,
    required this.setParent,
  });

  @override
  State<FriendsContent> createState() => _FriendsContentState();
}

class _FriendsContentState extends State<FriendsContent> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.viewModel.updateFriendList().then((value) {
          widget.setParent();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
          itemCount: widget.viewModel.friendsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Dismissible(
                direction: DismissDirection.endToStart,
                behavior: HitTestBehavior.deferToChild,
                background: Card(
                  color: Theme.of(context).colorScheme.error,
                  child: Center(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onError),
                    ),
                  ),
                ),
                key: ValueKey<int>(widget.viewModel.friendsList[index].userId),
                confirmDismiss: (DismissDirection direction) async {
                  bool? result = await removeFriendDialogBuilder(context);
                  if (result) {
                    await widget.viewModel
                        .removeFriend(widget.viewModel.friendsList[index])
                        .then((_) {
                      setState(() {});
                      widget.setParent();
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    });
                  }
                  return result;
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.viewModel.friendsList[index].firstName} ${widget.viewModel.friendsList[index].lastName}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                            'Steps: ${widget.viewModel.friendsList[index].activity?.steps ?? '0'}',
                            style: Theme.of(context).textTheme.bodySmall),
                        Text(
                            'Active Calories: ${widget.viewModel.friendsList[index].activity?.calories.toInt() ?? '0'}',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  )),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

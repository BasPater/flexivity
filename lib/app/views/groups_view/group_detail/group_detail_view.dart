import 'package:flexivity/app/helper/get_medal.dart';
import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_detail/group_manage_sheet.dart';
import 'package:flexivity/app/views/groups_view/group_detail/stage.dart';
import 'package:flexivity/app/views/loading_view/loading_view.dart';
import 'package:flexivity/app/widgets/navbar_widget.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/models/member.dart';
import 'package:flexivity/presentation/groups_view_model/group_detail_view_model/group_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/responses/get_group_with_activity_at_date_response.dart';

class GroupDetailScreen extends State<GroupDetailViewModel>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void didUpdateWidget(covariant GroupDetailViewModel oldWidget) {
    _getGroupInformation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _getGroupInformation();
    super.initState();
  }


  Future _getGroupInformation() async {
    await widget.getGroupInformation().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        actions: [
          if (widget.uiState == UIState.normal)
          IconButton(
            onPressed: () async {
              return openManageGroupBottomSheet(context, widget, () {
                setState(() {});
              });
            },
            icon: const Icon(Icons.manage_accounts_outlined),
          ),
        ],
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              text: 'Today',
            ),
            Tab(
              text: 'Yesterday',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UIStateSwitcher(
            uiState: widget.uiState,
            normalState: GroupDetailContent(
              viewModel: widget,
              group: widget.groupToday,
              onRefresh: () {
                return _getGroupInformation();
              },
            ),
            loadingState: LoadingView(),
          ),
          UIStateSwitcher(
            uiState: widget.uiState,
            normalState: GroupDetailContent(
              viewModel: widget,
              group: widget.groupYesterday,
              onRefresh: () {
                return _getGroupInformation();
              },
            ),
            loadingState: LoadingView(),
          )
        ],
      ),
      bottomNavigationBar: NavbarWidget(
        index: 2,
      ),
    );
  }
}

class GroupDetailContent extends StatefulWidget {
  final GroupDetailViewModel viewModel;
  final GetGroupWithActivityAtDateResponse? group;
  final Future Function() onRefresh;

  const GroupDetailContent({
    super.key,
    required this.viewModel,
    required this.group,
    required this.onRefresh,
  });

  @override
  State<GroupDetailContent> createState() => _GroupDetailContentState();
}

class _GroupDetailContentState extends State<GroupDetailContent> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return widget.onRefresh();
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ConstrainedBox(
            constraints: constraints.copyWith(minHeight: constraints.maxHeight),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if ((widget.group?.members.length ?? 0) >= 2)
                            Flexible(
                                child: Stage(
                                    height: 90,
                                    name:
                                        '${widget.group?.members[1].user.getFullname()}',
                                    place: 2,
                                    steps: widget
                                            .group?.members[1].activity.steps ??
                                        0)),
                          if ((widget.group?.members.length ?? 0) >= 1)
                            Flexible(
                                child: Stage(
                                    height: 120,
                                    name:
                                        '${widget.group?.members[0].user.getFullname()}',
                                    place: 1,
                                    steps: widget
                                            .group?.members[0].activity.steps ??
                                        0)),
                          if ((widget.group?.members.length ?? 0) >= 3)
                            Flexible(
                              child: Stage(
                                height: 60,
                                name:
                                    '${widget.group?.members[2].user.getFullname()}',
                                place: 3,
                                steps:
                                    widget.group?.members[2].activity.steps ??
                                        0,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            ((widget.group?.members.length ?? 0) - 3) <= 0
                                ? 0
                                : ((widget.group?.members.length ?? 0) - 3),
                        itemBuilder: (BuildContext context, int index) {
                          Member? currentMember =
                              widget.group?.members[index + 3];

                          return Material(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: ListTile(
                              leading: Text(
                                getMedal(index + 4),
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              title: Text(
                                '${currentMember?.user.getFullname()}',
                              ),
                              trailing: Text(
                                (currentMember?.activity.steps ?? 0).toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

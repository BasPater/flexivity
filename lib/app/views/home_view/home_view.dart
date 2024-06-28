import 'dart:async';

import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/home_view/widgets/step_goal_gauge/step_goal_gauge.dart';
import 'package:flexivity/app/widgets/navbar_widget.dart';
import 'package:flexivity/app/views/home_view/widgets/activity_list.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/models/errors/api_authentication_exception.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/presentation/home_view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends State<HomeViewModel> {
  @override
  void initState() {
    widget.loadData(context).then(
      (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          widget.uiState = UIState.normal;
        });
      },
    ).onError<ApiException>((e, _) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomeViewModel oldWidget) {
    widget.loadData(context).then(
          (_) {
        setState(() {
          widget.uiState = UIState.normal;
        },);
      },
    ).onError<ApiException>((e, _) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Home')),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        leading: Container(),
        actions: [
          IconButton(onPressed: () => context.push('/profile'), icon: Icon(Icons.account_circle_outlined))
        ],
      ),
      body: UIStateSwitcher(
        uiState: widget.uiState,
        loadingState: const Center(
          child: CircularProgressIndicator(),
        ),
        normalState: HomeContent(viewModel: widget),
      ),
      bottomNavigationBar: const NavbarWidget(index: 0),
    );
  }
}

class HomeContent extends StatefulWidget {
  final HomeViewModel viewModel;

  HomeContent({super.key, required this.viewModel});

  @override
  State<StatefulWidget> createState() => _HomeContentView();
}

class _HomeContentView extends State<HomeContent> {
  static const cacheUpdateNum = 10;
  static const bodyPadding = EdgeInsets.only(
    left: 20.0,
    right: 20.0,
    top: 40.0,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: bodyPadding,
            child: Center(
              child: StepGoalGauge(
                completedColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.85),
                uncompletedColor: Theme.of(context).colorScheme.secondary,
                stepGoal: widget.viewModel.stepGoal,
                totalSteps: widget.viewModel.steps,
                duration: const Duration(milliseconds: 900),
                size: const Size.square(280.0),
              ),
            ),
          ),
          Padding(
            padding: bodyPadding,
            child: ActivityList(activityRecords: widget.viewModel.activities),
          ),
          Center(
            child: FilledButton(
              child: const Text("Load more"),
              onPressed: () async {
                try {
                  final activities = await widget.viewModel.loadNextActivities(
                    widget.viewModel.activities.length,
                    widget.viewModel.activities.length + cacheUpdateNum,
                  );

                  if (activities.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No older activities found!')));
                    return;
                  }

                  widget.viewModel.activities.addAll(activities);
                } on ApiAuthenticationException {
                  widget.viewModel.logOut(context);
                } on ApiException catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message)));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

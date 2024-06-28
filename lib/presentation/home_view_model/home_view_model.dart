import 'dart:async';

import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/app/views/home_view/home_view.dart';
import 'package:flexivity/data/models/errors/api_authentication_exception.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flexivity/domain/repositories/activity/abstract_activity_repository.dart';
import 'package:flexivity/domain/repositories/credentials/abstract_credentials_repository.dart';
import 'package:flexivity/domain/repositories/health/abstract_health_repository.dart';
import 'package:flexivity/domain/repositories/preferences/abstract_preferences_repository.dart';
import 'package:flexivity/presentation/helper/credentials_helper.dart'
    as credHelper;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class HomeViewModel extends StatefulWidget {
  static const int cacheUpdateAmount = 10;

  final List<Activity> activities;

  final ICredentialsRepository credRepo;
  final IHealthRepository healthRepo;
  final IActivityRepository activityRepo;
  final IPreferencesRepository prefRepo;

  int steps;
  int stepGoal;
  UIState uiState;

  HomeViewModel({
    super.key,
    ICredentialsRepository? credRepo,
    required this.healthRepo,
    required this.activityRepo,
    required this.prefRepo,
  })  : credRepo = credRepo ?? CredentialsRepository(),
        this.activities = List.empty(growable: true),
        this.uiState = UIState.loading,
        this.stepGoal = 0,
        this.steps = 0;

  @override
  State<HomeViewModel> createState() => HomeView();

  /// Loads the initial data for the page
  Future<void> loadData(BuildContext context) async {
    try {
      // Get activities for the past 10 days
      List<Activity> prevActivities = await this.loadNextActivities(
        0,
        cacheUpdateAmount,
      );
      // Check if a record was created for today
      // If, get todays local activity
      if (!prevActivities.any(
        (element) => DateUtils.isSameDay(element.activityAt, DateTime.now()),
      )) {
        activities.insert(
          0,
          await this.loadTodaysActivity() ?? Activity(0, 0, 0, DateTime.now()),
        );
      }
      // Add the remaining
      activities.addAll(prevActivities);

      // Set the step goal and steps
      String? stepGoalString = await this.prefRepo.getStepGoal();
      stepGoal = stepGoalString != null ? int.parse(stepGoalString) : 0;
      steps = activities.first.steps;
    } on ApiAuthenticationException {
      this.logOut(context);
    } on ApiException catch (e) {
      return Future.error(e);
    }
  }

  /// Loads todays activity from the health repository
  Future<Activity?> loadTodaysActivity() async {
    return this.healthRepo.getTodaysActivity();
  }

  /// Loads the next activities
  Future<List<Activity>> loadNextActivities(int from, int to) async {
    return this.activityRepo.getActivities(
          Globals.credentials!.userId,
          from,
          to,
        );
  }

  /// Logs out the user
  void logOut(BuildContext context) {
    credHelper.logOut(this.credRepo);

    try {
      if (!context.mounted) {
        return;
      }

      GoRouter.of(context).go('/');
    } catch (e) {
      return;
    }
  }
}

import 'package:flexivity/app/views/loading_view/loading_view.dart';
import 'package:flexivity/app/views/profile_view/delete_account_dialog.dart';
import 'package:flexivity/app/views/profile_view/edit_profile_dialog.dart';
import 'package:flexivity/app/views/profile_view/error_view.dart';
import 'package:flexivity/app/views/profile_view/log_out_dialog.dart';
import 'package:flexivity/app/views/profile_view/step_goal_dialog.dart';
import 'package:flexivity/app/widgets/navbar_widget.dart';
import 'package:flexivity/app/widgets/snackbars/delete_account_snack_bar.dart';
import 'package:flexivity/app/widgets/snackbars/edit_profile_snack_bar.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/presentation/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreenState extends State<ProfileScreenViewModel> {
  @override
  void initState() {
    super.initState();
    setState(() {});
    widget.getUser().then(
      (_) async {
        await widget.getStepGoal();
        setState(() {});
      },
    );
  }

  @override
  void didUpdateWidget(covariant ProfileScreenViewModel oldWidget) {
    setState(() {});
    widget.getUser().then(
      (_) async {
        await widget.getStepGoal();
        setState(() {});
      },
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
      ),
      body: UIStateSwitcher(
        uiState: widget.uiState,
        normalState: ProfileContent(
          viewModel: widget,
        ),
        loadingState: const LoadingView(),
        errorState: ProfileErrorView(
          text: 'An error occurred',
          iconData: Icons.error,
          onPressed: () async {
            await widget
                .logout()
                .then((value) => GoRouter.of(context).go('/start'));
          },
        ),
      ),
      bottomNavigationBar: const NavbarWidget(index: 0),
    );
  }
}

class ProfileContent extends StatefulWidget {
  final ProfileScreenViewModel viewModel;

  const ProfileContent({super.key, required this.viewModel});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.viewModel.user?.firstName ?? "First"} ${widget.viewModel.user?.lastName ?? "Last"}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "Username: ${widget.viewModel.user?.userName ?? "User"}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(),
                  ),
                  ListTile(
                    onTap: () {
                      editProfileDialLogBuilder(
                        context,
                        widget.viewModel.firstNameController,
                        widget.viewModel.lastNameController,
                        () => {
                          widget.viewModel.updateUser().onError(
                            (error, stackTrace) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(editProfileSnackBar);
                            },
                          ).then(
                            (_) => {
                              setState(() {})
                              // This will trigger a rebuild of the widget
                            },
                          ),
                        },
                      );
                    },
                    leading: const Icon(Icons.edit),
                    title: const Text("Edit Profile"),
                  ),
                  ListTile(
                    onTap: () {
                      GoRouter.of(context).push('/change-password');
                    },
                    leading: const Icon(Icons.password),
                    title: const Text("Change password"),
                  ),
                  ListTile(
                    onTap: () {
                      deleteAccountDialLogBuilder(
                        context,
                        widget.viewModel.deleteAccountController,
                        () {
                          widget.viewModel.deleteUser().then(
                            (value) {
                              GoRouter.of(context).go('/start');
                            },
                          ).onError(
                            (error, stackTrace) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(deleteAccountSnackBar);
                            },
                          );
                        },
                      );
                    },
                    leading: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      "Delete account",
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      logOutDialogBuilder(
                          context,
                          () => widget.viewModel.logout().then(
                              (value) => GoRouter.of(context).go('/start')));
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text("Log out"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.directions_walk),
                title: const Text("Set step goal"),
                onTap: () => stepGoalDialogBuilder(
                    context,
                    widget.viewModel.stepGoalController,
                    () => {
                          setState(() {
                            widget.viewModel.setStepGoal();
                          })
                        }),
                trailing:
                    Text("${widget.viewModel.stepGoalController.text} steps"),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Builder(builder: (BuildContext context) {
              if (widget.viewModel.user?.role != "ADMIN") {
                return const SizedBox();
              }
              return const Card(
                elevation: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.admin_panel_settings),
                        title: Text("Admin panel"),
                      ),
                    ]),
              );
            }),
          ],
        ),
      ),
    );
  }
}

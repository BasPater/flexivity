import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../data/models/errors/api_exception.dart';
import '../../../presentation/profile_view_model/change_password_view_model.dart';
import '../../models/ui_state.dart';
import '../../widgets/full_width_button.dart';

class ChangePasswordViewState extends State<ChangePasswordViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: const Text('Change Password'),
      ),
      body: ChangePasswordStepTwoContent(viewModel: widget),
    );
  }
}

class ChangePasswordStepTwoContent extends StatefulWidget {
  final ChangePasswordViewModel viewModel;

  const ChangePasswordStepTwoContent({required this.viewModel});

  @override
  State<ChangePasswordStepTwoContent> createState() => _ContentState();
}

class _ContentState extends State<ChangePasswordStepTwoContent> {
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  Future send() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        // Access the token from the viewModel
        widget.viewModel.uiState = UIState.loading;
      });
      await widget.viewModel.changePassword().then((value) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request sent successfully!')));
        try {
          GoRouter.of(context).push('/profile');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (e.toString()),
              ),
            ),
          );
        }
      }).onError((error, stackTrace) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((error as ApiException).message),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Current password",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextFormField(
                  obscureText: widget.viewModel.hideOldPassword,
                  autofillHints: const [AutofillHints.password],
                  autofocus: true,
                  focusNode: focusNode,
                  autocorrect: false,
                  controller: widget.viewModel.oldPasswordInputController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Current password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          widget.viewModel.changeVisibilityOldPasswordField();
                        });
                      },
                      icon: Icon(widget.viewModel.hideOldPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Text(
                  "New password",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextFormField(
                  obscureText: widget.viewModel.hidePassword,
                  autofillHints: const [AutofillHints.password],
                  autocorrect: false,
                  controller: widget.viewModel.passwordInputController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return widget.viewModel.isValidPassword(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          widget.viewModel.changeVisibilityPasswordField();
                        });
                      },
                      icon: Icon(widget.viewModel.hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  obscureText: widget.viewModel.hideConfirmPassword,
                  autofillHints: const [AutofillHints.password],
                  autocorrect: false,
                  controller: widget.viewModel.confirmPasswordInputController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return widget.viewModel.isValidPassword(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          widget.viewModel.changeVisibilityConfirmPassword();
                        });
                      },
                      icon: Icon(widget.viewModel.hideConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                FullWidthButton(
                  label: "Send",
                  onPressed: () => send(),
                  isLoading: widget.viewModel.uiState == UIState.loading,
                ),
                const SizedBox(
                  height: 4.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

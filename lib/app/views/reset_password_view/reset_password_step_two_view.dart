import 'dart:async';

import 'package:flexivity/presentation/reset_password_view_model/reset_password_step_two_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../data/models/errors/api_exception.dart';
import '../../models/ui_state.dart';
import '../../widgets/full_width_button.dart';

class ResetPasswordStepTwoViewState extends State<ResetPasswordStepTwoViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/'),
        ),
        title: const Text('Forgot Password'),
      ),
      body: ResetPasswordStepTwoContent(viewModel: widget),
    );
  }
}

class ResetPasswordStepTwoContent extends StatefulWidget {
  final ResetPasswordStepTwoViewModel viewModel;

  const ResetPasswordStepTwoContent({required this.viewModel});

  @override
  State<ResetPasswordStepTwoContent> createState() => _ContentState();
}

class _ContentState extends State<ResetPasswordStepTwoContent> {

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
      await widget.viewModel.reset().then((value) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request sent successfully!')));
        try {
          GoRouter.of(context).push('/login');
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Change your password, by entering two valid and identical passwords.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextFormField(
              obscureText: widget.viewModel.hidePassword,
              autofillHints: const [AutofillHints.password],
              autofocus: true,
              focusNode: focusNode,
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
            TextFormField(
              obscureText: widget.viewModel.hideConfirmPassword,
              autofillHints: const [AutofillHints.password],
              autocorrect: false,
              controller: widget.viewModel.rePasswordInputController,
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
    );
  }
}

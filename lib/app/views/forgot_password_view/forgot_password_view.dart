import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/errors/api_exception.dart';
import '../../../presentation/forgot_password_view_model/forgot_password_view_model.dart';
import '../../models/ui_state.dart';
import '../../widgets/full_width_button.dart';

class ForgotPasswordViewModelState extends State<ForgotPasswordViewModel> {
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
      body: ForgotPasswordContent(viewModel: widget),
    );
  }
}

class ForgotPasswordContent extends StatefulWidget {
  final ForgotPasswordViewModel viewModel;

  const ForgotPasswordContent({required this.viewModel});

  @override
  State<ForgotPasswordContent> createState() => _ContentState();
}

class _ContentState extends State<ForgotPasswordContent> {
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  Future send() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.viewModel.uiState = UIState.loading;
      });
      await widget.viewModel.send().then((value) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request sent successfully!')));
        try {
          GoRouter.of(context).push('/reset_password');
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
    // UI for login page with the ability to go back or go to the sign up page.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Send a password reset code to your email. By entering your email down below.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextFormField(
                  controller: widget.viewModel.emailInputController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onEditingComplete: () => send(),
                  autofocus: true,
                  focusNode: focusNode,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(hintText: "E-mail"),
                  textInputAction: TextInputAction.send,
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
              ])),
    );
  }
}

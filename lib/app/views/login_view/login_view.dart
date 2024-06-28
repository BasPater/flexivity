import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/presentation/login_view_model/login_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginViewModelState extends State<LoginViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/'),
        ),
      ),
      body: _Content(viewModel: widget),
    );
  }
}

class _Content extends StatefulWidget {
  final LoginViewModel viewModel;

  const _Content({required this.viewModel});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // UI for login page with the ability to go back or go to the sign up page.
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Image(
                  width: 200,
                  height: 200,
                  image: AssetImage(
                      'lib/app/assets/app_icon/app_icon_square_rounded.png')),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Login',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: widget.viewModel.emailInputController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(hintText: "E-mail"),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                obscureText: widget.viewModel.isPasswordVisible,
                autofillHints: const [AutofillHints.password],
                autocorrect: false,
                controller: widget.viewModel.passwordInputController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.viewModel.changePasswordVisibility();
                      });
                    },
                    icon: Icon(widget.viewModel.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              FullWidthButton(
                  isLoading: widget.viewModel.uiState == UIState.loading,
                  label: "Login",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        widget.viewModel.uiState = UIState.loading;
                      });
                      await widget.viewModel.login().then((value) {
                        setState(() {});
                        GoRouter.of(context).go('/home');
                      }).catchError((e) {
                        setState(() {});
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(e.message)));
                      });
                    }
                  }),
              const SizedBox(
                height: 4.0,
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelLarge,
                  children: <TextSpan>[
                    const TextSpan(text: 'If you don\'t have an account yet, '),
                    TextSpan(
                      text: 'create one here.',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => GoRouter.of(context).push("/sign_up"),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelLarge,
                  children: <TextSpan>[
                    const TextSpan(text: 'If you forgot your password, '),
                    TextSpan(
                      text: 'change it here.',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => GoRouter.of(context).push("/forgot_password"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

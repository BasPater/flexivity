import 'package:flexivity/app/constants/password_requirements.dart';
import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/presentation/sign_up_view_model/sign_up_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends State<SignUpViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: _Content(viewModel: widget),
    );
  }
}

class _Content extends StatefulWidget {
  final SignUpViewModel viewModel;

  const _Content({required this.viewModel});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //UI for sign up page. With form validation and the ability to go back and go to the login page.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Let\'s by start making your account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16.0),
              TextFormField(
                  controller: widget.viewModel.firstNameInputController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "First Name")),
              const SizedBox(height: 16.0),
              TextFormField(
                  controller: widget.viewModel.lastNameInputController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Last Name")),
              const SizedBox(height: 32.0),
              TextFormField(
                  controller: widget.viewModel.usernameInputController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Username")),
              const SizedBox(height: 16.0),
              TextFormField(
                  controller: widget.viewModel.emailInputController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!widget.viewModel.isValidEmail(value)) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(hintText: "E-mail")),
              const SizedBox(height: 16.0),
              TextFormField(
                obscureText: widget.viewModel.isPasswordVisible,
                autocorrect: false,
                autofillHints: const [AutofillHints.newPassword],
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
                label: "Sign Up",
                isLoading: widget.viewModel.uiState == UIState.loading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      widget.viewModel.uiState = UIState.loading;
                    });
                    await widget.viewModel.register().then((value) {
                      setState(() {});
                      GoRouter.of(context).go('/home');
                    }).catchError((e) {
                      setState(() {});
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.message)));
                    });
                  }
                },
              ),
              const SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelLarge,
                  children: <TextSpan>[
                    const TextSpan(text: 'If you already have an account, '),
                    TextSpan(
                      text: 'login here.',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => GoRouter.of(context).push("/login"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  passwordRequirements,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

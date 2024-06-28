import 'dart:async';

import 'package:flexivity/presentation/reset_password_view_model/reset_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../data/models/errors/api_exception.dart';
import '../../models/ui_state.dart';
import '../../widgets/full_width_button.dart';

class ResetPasswordViewModelState extends State<ResetPasswordViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: const Text('Forgot Password'),
      ),
      body: ResetPasswordContent(viewModel: widget),
    );
  }
}

class ResetPasswordContent extends StatefulWidget {
  final ResetPasswordViewModel viewModel;

  const ResetPasswordContent({required this.viewModel});

  @override
  State<ResetPasswordContent> createState() => _ContentState();
}

class _ContentState extends State<ResetPasswordContent> {
  TextEditingController textEditingController = TextEditingController();

  Future check() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.viewModel.uiState = UIState.loading;
      });
      await widget.viewModel.check().then((value) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request sent successfully!')));
        try {
          GoRouter.of(context).push(
              '/reset_password_step_two/${widget.viewModel.textEditingController.text}');
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

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

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
              'Enter your verification code: ',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16.0),
            PinCodeTextField(
              appContext: context,
              pastedTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              length: 6,
              obscureText: true,
              obscuringCharacter: '*',
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              validator: (v) {
                if (v == "" || v!.length < 6) {
                  return 'Please enter your code';
                }
                return null;
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                activeColor: Theme.of(context).colorScheme.primary,
                inactiveColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
                selectedColor: Theme.of(context).colorScheme.primary,
                selectedFillColor: Theme.of(context).colorScheme.primary.withOpacity(.5),
                inactiveFillColor: Colors.grey.shade100,
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              errorAnimationController: errorController,
              controller: widget.viewModel.textEditingController,
              focusNode: focusNode,
              autoFocus: true,
              keyboardType: TextInputType.text,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
              onCompleted: (v) => check(),
              textInputAction: TextInputAction.send,
              onEditingComplete: check,
            ),
            const SizedBox(height: 16.0),
            FullWidthButton(
                label: "Check",
                onPressed: () => check(),
                isLoading: widget.viewModel.uiState == UIState.loading),
            const SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );

    // Second input field (conditionally shown)
  }
}

import 'package:flutter/material.dart';

Future<void> deleteAccountDialLogBuilder(
    BuildContext context, TextEditingController controller, Function() onDelete) {

  final focusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Are you sure?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Type \"CONFIRM\" in the textfield below to confirm the deletion of your account."),
            Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                autofocus: true,
                autocorrect: false,
                focusNode: focusNode,
                validator: (input) {
                  if (input != "CONFIRM") {
                    return "Confirm the deletion of your account";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  if (formKey.currentState!.validate()) {
                    onDelete();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Delete'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onDelete();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
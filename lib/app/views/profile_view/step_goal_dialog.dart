import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> stepGoalDialogBuilder(
    BuildContext context, TextEditingController controller, Function() onSave) {

  final focusNode = FocusNode();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Set step goal"),
        content: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          autofocus: true,
          focusNode: focusNode,
          onFieldSubmitted: (_) {
            onSave();
            Navigator.of(context).pop();
          },
          decoration: const InputDecoration(
            prefix: Text("Steps: \t")
          ),
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
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Save'),
            onPressed: () {
              onSave();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

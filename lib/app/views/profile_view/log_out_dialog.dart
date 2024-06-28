import 'package:flutter/material.dart';

Future<void> logOutDialogBuilder(
    BuildContext context, Function() onLogout) {

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text('Are you sure you want to log out?'),
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
            child: const Text('Yes, log out'),
            onPressed: () {
              onLogout();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

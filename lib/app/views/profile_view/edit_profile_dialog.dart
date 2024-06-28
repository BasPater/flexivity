import 'package:flutter/material.dart';

Future<void> editProfileDialLogBuilder(
    BuildContext context,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    Function() onSave) {
  final formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit your profile'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('First name:', style: Theme.of(context).textTheme.bodyLarge,),
              TextFormField(
                controller: firstNameController,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'This field can\'t be empty';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  if (formKey.currentState!.validate()) {
                    onSave();
                    Navigator.of(context).pop();
                  }
                },
                decoration: const InputDecoration(hintText: 'First Name'),
              ),
              const SizedBox(height: 8.0,),
              Text('Last name:', style: Theme.of(context).textTheme.bodyLarge,),
              TextFormField(
                controller: lastNameController,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'This field can\'t be empty';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  if (formKey.currentState!.validate()) {
                    onSave();
                    Navigator.of(context).pop();
                  }
                },
                decoration: const InputDecoration(hintText: 'Last Name'),
              ),
            ],
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
              if (formKey.currentState!.validate()) {
                onSave();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

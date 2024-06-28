import 'package:flexivity/presentation/groups_view_model/group_detail_view_model/group_detail_view_model.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteGroupDialog(
    BuildContext context, GroupDetailViewModel viewModel) {
  return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text("Are you sure?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "Type \"CONFIRM\" in the textfield below to confirm the deletion of this group."),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: viewModel.deleteGroupController,
                  autofocus: true,
                  autocorrect: false,
                  validator: (input) {
                    if (input != "CONFIRM") {
                      return "Confirm the deletion of this group";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).pop(true);
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
                Navigator.of(context).pop(false);
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
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      }).then((value) => value ?? false);
}

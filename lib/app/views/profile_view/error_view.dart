import 'package:flexivity/app/views/profile_view/log_out_dialog.dart';
import 'package:flutter/material.dart';

class ProfileErrorView extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final IconData iconData;

  const ProfileErrorView({
    super.key,
    required this.text,
    required this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData,
                size: 100, color: Theme.of(context).colorScheme.secondary),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8.0,),
            Card(
              child: ListTile(
                onTap: () {
                  logOutDialogBuilder(context, () {
                    onPressed();
                  });
                },
                leading: const Icon(Icons.logout),
                title: const Text("Log out"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

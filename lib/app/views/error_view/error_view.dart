import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Widget? optionalWidget;

  const ErrorView({
    super.key,
    this.text = 'An error occurred',
    this.iconData = Icons.error_outline_outlined,
    this.optionalWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              height: 8.0,
            ),
            if (optionalWidget != null) optionalWidget!,
          ],
        ),
      ),
    );
  }
}

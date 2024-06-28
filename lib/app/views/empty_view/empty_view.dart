import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String text;
  final String? buttonText;
  final Function()? onPressed;
  final IconData iconData;

  const EmptyView({
    super.key,
    required this.text,
    this.buttonText,
    this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
          if (buttonText != null && onPressed != null)
            FilledButton(onPressed: onPressed!, child: Text(buttonText!))
        ],
      ),
    );
  }
}

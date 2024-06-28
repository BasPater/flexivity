import 'package:flutter/material.dart';

class FullWidthButton extends StatefulWidget {
  final String label;
  final void Function() onPressed;
  final ButtonStyle? style;
  final bool isLoading;

  const FullWidthButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.style,
      this.isLoading = false});

  @override
  State<FullWidthButton> createState() => _FullWidthButtonState();
}

class _FullWidthButtonState extends State<FullWidthButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
          onPressed: widget.onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 34.0,
              child:  widget.isLoading
                  ? CircularProgressIndicator(
                color: Theme.of(context).secondaryHeaderColor,
              )
                  : Text(
                widget.label,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white),
              ),
            )
          )),
    );
  }
}

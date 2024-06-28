import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

Future showPanel(Widget child, BuildContext context) async {
  final result = await Overlayment.show(
      OverPanel(child: child, alignment: Alignment.bottomCenter),context: context);
  if (result != null) {
    await OverNotification(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: result,
      ),
      color: Colors.amber,
    ).show();
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListDateDivider extends StatelessWidget {
  final DateTime date;

  const ListDateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) => Row(
      children: [
        const Expanded(
          child: Divider(endIndent: 12.0, thickness: 2.0),
        ),
        Text(
          DateFormat('MMMM yyyy').format(date), 
          style: const TextStyle(fontSize: 20.0)
        ),
        const Expanded(
          child: Divider(indent: 12.0, thickness: 2.0),
        ),
      ],
    );
}

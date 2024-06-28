import 'package:flexivity/app/helper/get_medal.dart';
import 'package:flutter/material.dart';

class Stage extends StatefulWidget {
  final String name;
  final int steps;
  final double height;
  final int place;

  const Stage(
      {super.key,
      required this.name,
      required this.steps,
      required this.height,
      required this.place,});

  @override
  State<Stage> createState() => _StageState();
}

class _StageState extends State<Stage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          widget.name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Container(
          child: Column(
            children: [
              Text(
                getMedal(widget.place),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                widget.steps.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              )
            ],
          ),
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(widget.height / 120),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
        ),
      ],
    );
  }
}

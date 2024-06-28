import 'package:flexivity/data/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityListItem extends StatelessWidget {
  final Activity activity;

  const ActivityListItem({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Text(
            DateFormat('dd MMMM yyyy').format(activity.activityAt),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Steps ',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    activity.steps.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(children: [
                Text(
                  'Calories ',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  activity.calories.toInt().toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ]),
            ],
          )),
    );
  }
}

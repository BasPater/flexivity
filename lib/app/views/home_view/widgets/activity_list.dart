import 'package:flexivity/app/views/home_view/widgets/activity_list_item.dart';
import 'package:flexivity/app/views/home_view/widgets/list_date_divider.dart';
import 'package:flexivity/data/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityList extends StatefulWidget {
  final List<Activity> activityRecords;

  const ActivityList({super.key, required this.activityRecords});

  @override
  State<StatefulWidget> createState() => _ActivityList();
}

class _ActivityList extends State<ActivityList> {
  @override
  Widget build(BuildContext context) => ListView.separated(
    itemCount: widget.activityRecords.length + 1,
    itemBuilder: (context, index) {
      if (index == 0) {
        if (widget.activityRecords.isEmpty) {
          return null;
        }

        return ListDateDivider(date: widget.activityRecords[0].activityAt);
      }

      return ActivityListItem(activity: widget.activityRecords[index - 1]);
    },
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    separatorBuilder: (context, index) => createListSpacing(
      index == 0 ? null : widget.activityRecords[index - 1],
      widget.activityRecords[index],
    ),
  );

  Widget createListSpacing(Activity? prev, Activity current) {
    if (prev == null ||
        prev.activityAt.month <= current.activityAt.month &&
            prev.activityAt.year <= current.activityAt.year) {
      return const SizedBox(height: 10.0);
    }

    return ListDateDivider(date: current.activityAt);
  }
}

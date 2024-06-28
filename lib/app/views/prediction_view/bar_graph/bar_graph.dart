import 'package:fl_chart/fl_chart.dart';
import 'package:flexivity/data/models/prediction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class BarGraph extends StatefulWidget {
  final List<Prediction> weeklySummery;

  const BarGraph({Key? key, required this.weeklySummery}) : super(key: key);

  @override
  State<BarGraph> createState() => _BarGraphScreen();
}

class _BarGraphScreen extends State<BarGraph> {
  Future<List<String>> getDays() async {
    List<String> days = [];
    for (int i = 0; i < widget.weeklySummery.length; i++) {
      days.add(await getDay(i));
    }
    return days;
  }

  String getDay(int index) {
    DateTime date = DateTime.parse(widget.weeklySummery.elementAt(index).date);
    return DateFormat('d MMM', 'en_US').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getDays(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return BarGraphContent(weeklySummery: widget.weeklySummery, days: snapshot.data!);
        }
      },
    );
  }
}
class BarGraphContent extends StatefulWidget {
  final List<Prediction> weeklySummery;
  final List<String> days;

  const BarGraphContent({super.key, required this.weeklySummery, required this.days});

  @override
  State<BarGraphContent> createState() => _BarGraphContentState();
}

class _BarGraphContentState extends State<BarGraphContent> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY:  (widget.weeklySummery
            .reduce((curr, next) => curr.score > next.score ? curr : next)
            .score *
            1.1).round().toDouble(),
        // invert the y-axis
        minY: 0,
        // set the minimum y value to the lowest score
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            axisNameWidget: Text(
              'Score (lower is better)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            sideTitles: SideTitles(
              showTitles: true,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                String text = widget.days[value.toInt()];
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Transform.rotate(
                    angle: 45 * 3.14159265 / 180,
                    // convert 45 degrees to radians
                    child: Text(text),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: widget.weeklySummery.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                fromY: entry.value.score,
                color: Theme.of(context).colorScheme.primary,
                toY: 0,
                width: 25,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  fromY: 0,
                  toY: widget.weeklySummery
                      .reduce((curr, next) =>
                  curr.score > next.score ? curr : next)
                      .score *
                      1.1,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

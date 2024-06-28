import 'package:flexivity/app/views/home_view/widgets/step_goal_gauge/step_goal_gauge_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StepGoalGauge extends StatefulWidget {
  final Duration duration;
  final int stepGoal;
  final int totalSteps;
  final Curve curve;
  final Size size;
  final Color? completedColor;
  final Color? uncompletedColor;

  const StepGoalGauge({
    super.key,
    required this.stepGoal,
    required this.totalSteps,
    required this.duration,
    required this.size,
    this.curve = Curves.linear,
    this.completedColor,
    this.uncompletedColor,
  });

  @override
  State<StatefulWidget> createState() => StepGoalGaugeState();
}

class StepGoalGaugeState extends State<StepGoalGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addListener(() => setState(() {}));
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StepGoalIndicatorPainter(
        theme: Theme.of(context),
        stepGoal: widget.stepGoal,
        totalSteps:
            (widget.curve.transform(_controller.value) * widget.totalSteps)
                .toInt(),
        completedColor: widget.completedColor ?? Colors.green,
        uncompletedColor: widget.uncompletedColor ?? Colors.blueGrey,
      ),
      size: const Size.square(280.0),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math';

typedef DrawFunction = void Function(
    Canvas canvas, Rect bounds, Point position);

class StepGoalIndicatorPainter extends CustomPainter {
  static const double innerIndicatorSeparatorHeight = 5;
  static const double defaultStrokeWidth = 20.0;
  static const double defaultFontSize = 30.0;
  static const double padding = 0.0;
  static const double halfCircle = 180.0;
  static const double fullCircle = 360.0;
  static const double bottomOffset = 40.0;
  static const double startAngle = halfCircle - bottomOffset;
  static const double sweepAngle = halfCircle + bottomOffset * 2;
  static const double topLeftCircleAngle = halfCircle + 45.0;
  static const double bottomRightCircleAngle = 45.0;

  static const double maxPercentage = 100.0;
  static const Size minSize = Size.square(50.0);

  final ThemeData? theme;
  final int stepGoal;
  final int totalSteps;
  final Color completedColor;
  final Color uncompletedColor;

  StepGoalIndicatorPainter({
    super.repaint,
    this.theme,
    required this.stepGoal,
    required this.totalSteps,
    this.completedColor = Colors.green,
    this.uncompletedColor = Colors.blueGrey,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width < minSize.width || size.height < minSize.height) {
      return;
    }

    // Define bounding rect for gauge
    Rect containerRect = Rect.fromPoints(
      const Offset(padding, padding),
      Offset(size.width - padding, size.height - padding),
    );

    double completedPercentage = (totalSteps / stepGoal) * maxPercentage;
    completedPercentage = completedPercentage <= maxPercentage
        ? completedPercentage
        : maxPercentage;

    // Draw the steps graph
    this._drawStepsGauge(
        canvas, containerRect, completedPercentage, totalSteps);

    // Draw the percentage
    drawInner(
      canvas,
      containerRect,
      '${completedPercentage.toStringAsFixed(2)}%',
    );

    // Draw the completed percentage
    this.drawStatus(
      canvas,
      containerRect,
      ['$totalSteps', '$stepGoal'],
    );
  }

  /// Draws the Arc graph for the goal percentage
  void _drawStepsGauge(
    Canvas canvas,
    Rect container,
    double percentage,
    int steps,
  ) {
    // Calculate completed angle
    double completedAngle = this._degreesForPercentage(
      percentage,
      sweepAngle,
    );

    // Calculate unfinished angle
    double unfinishedAngle = this._degreesForPercentage(
      maxPercentage - percentage,
      sweepAngle,
    );

    // Draw part of goal still to complete
    canvas.drawArc(
      container,
      this._degreesToRadians(startAngle + completedAngle),
      this._degreesToRadians(unfinishedAngle),
      false,
      this._getIncompletePaintStyle(defaultStrokeWidth),
    );

    // Draw part of completed goal
    canvas.drawArc(
      container,
      this._degreesToRadians(startAngle),
      this._degreesToRadians(completedAngle),
      false,
      this._getCompletedPaintStyle(defaultStrokeWidth),
    );
  }

  /// Draw the inner elements
  void drawInner(Canvas canvas, Rect container, String text) {
    // Create text painter
    final painter = TextPainter(
      text: TextSpan(text: text, style: this._getTitleStyle()),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Calculate text layout
    painter.layout();

    // Get the inner circle rectangle
    Rect innerRect = this._innerCircleRect(container);

    // Draw the text centered
    this.drawCenteredText(
      canvas,
      container,
      painter,
      this.halve(innerRect.height) + painter.height,
    );
  }

  /// Draw the status
  void drawStatus(Canvas canvas, Rect container, List<String> lines) {
    Point statusPoint = this._statusPos(container);
    this.drawStatusText(canvas, statusPoint, lines);
  }

  /// Draws the inner indicator text
  void drawStatusText(
    Canvas canvas,
    Point drawPos,
    List<String> lines,
  ) {
    List<TextPainter> painters = [];
    double height = 0.0;

    // Run through lines and layout text
    for (final (index, text) in lines.indexed) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: index > 0 ? this._getTextStyle() : this._getTitleStyle(),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      // Layout text
      painter.layout();

      height += painter.height.toDouble();
      painters.add(painter);
    }

    // Get full height to be drawn
    height += innerIndicatorSeparatorHeight * painters.length;

    // Start draw
    double yTop = drawPos.y - this.halve(height);
    double currY = yTop;
    for (final (index, painter) in painters.indexed) {
      if (index > 0) {
        double lineY = currY + this.halve(innerIndicatorSeparatorHeight);
        canvas.drawLine(
          Offset(drawPos.x - painter.width, lineY),
          Offset(drawPos.x + painter.width, lineY),
          this._getElementPaint(innerIndicatorSeparatorHeight),
        );

        currY += innerIndicatorSeparatorHeight;
      }

      // Draw the text
      painter.paint(
        canvas,
        Offset(
          drawPos.x - this.halve(painter.width),
          currY,
        ),
      );
      currY += painter.height;
    }
  }

  /// Gets the paint style used to display
  /// the complete part of the gauge
  Paint _getCompletedPaintStyle(double strokeWidth) {
    Paint finishedPaint = Paint();
    finishedPaint.style = PaintingStyle.stroke;
    finishedPaint.color = this.completedColor;
    finishedPaint.strokeWidth = strokeWidth;
    finishedPaint.isAntiAlias = true;
    finishedPaint.strokeCap = StrokeCap.round;

    return finishedPaint;
  }

  /// Gets the paint style used to display
  /// the incomplete part of the gauge
  Paint _getIncompletePaintStyle(double strokeWidth) {
    Paint incompletePaint = Paint();
    incompletePaint.style = PaintingStyle.stroke;
    incompletePaint.color = this.uncompletedColor;
    incompletePaint.strokeWidth = strokeWidth;
    incompletePaint.isAntiAlias = true;
    incompletePaint.strokeCap = StrokeCap.round;

    return incompletePaint;
  }

  Paint _getElementPaint(double strokeWidth) {
    Paint elementPaint = Paint();
    elementPaint.style = PaintingStyle.stroke;
    elementPaint.color = theme!.dividerColor;
    elementPaint.strokeWidth = strokeWidth;
    elementPaint.isAntiAlias = true;

    return elementPaint;
  }

  /// Gets the text style used by the gauge
  TextStyle _getTitleStyle() {
    if (theme?.textTheme.titleLarge == null) {
      return const TextStyle(
        color: Colors.black,
        fontSize: defaultFontSize,
      );
    }

    return theme!.textTheme.titleLarge!;
  }

  TextStyle _getTextStyle() {
    if (theme?.textTheme.titleMedium == null) {
      return const TextStyle(
        color: Colors.black,
        fontSize: defaultFontSize,
      );
    }

    return theme!.textTheme.titleMedium!;
  }

  void drawCenteredText(
    Canvas canvas,
    Rect container,
    TextPainter painter,
    double yPos,
  ) {
    double x = container.width / 2 - painter.width / 2;
    double y = yPos - painter.height / 2;
    painter.paint(canvas, Offset(x, y));
  }

  /// Get the drawable area inside the circle
  Rect _innerCircleRect(Rect container) {
    double radius = container.width / 2;

    // Get the bounds for the to be written text
    final topLeftPos = this._getPositionInCircle(
      radius,
      this._degreesToRadians(topLeftCircleAngle),
      this._getCenter(container),
    );
    final bottomRightPos = _getPositionInCircle(
      radius,
      _degreesToRadians(bottomRightCircleAngle),
      _getCenter(container),
    );

    // Create a rect for the bounds
    return Rect.fromPoints(
      Offset(
        topLeftPos.x.toDouble(),
        topLeftPos.y.toDouble(),
      ),
      Offset(
        bottomRightPos.x.toDouble(),
        bottomRightPos.y.toDouble(),
      ),
    );
  }

  /// Gets the position for the status text
  Point _statusPos(Rect container) {
    double radius = this.halve(container.width);

    final leftBottom = this._getPositionInCircle(
      radius,
      this._degreesToRadians(startAngle),
      this._getCenter(container),
    );
    final rightBottom = this._getPositionInCircle(
      radius,
      this._degreesToRadians(bottomOffset),
      this._getCenter(container),
    );

    double halfWidth =
        this.halve(rightBottom.x.toDouble() - leftBottom.x.toDouble());
    return Point(leftBottom.x + halfWidth,
        leftBottom.y + this.halve(defaultStrokeWidth));
  }

  /// Halves the given number
  double halve(double value) {
    return value / 2;
  }

  /// Coverts degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * pi / halfCircle;
  }

  /// Gets the degrees for the given percentage\
  double _degreesForPercentage(double percentage, double maxDegrees) {
    return (percentage / maxPercentage) * maxDegrees;
  }

  /// Gets the position of a point on a circle
  Point _getPositionInCircle(double radius, double radian, Point center) {
    return Point(
      radius * cos(radian) + center.x,
      radius * sin(radian) + center.y,
    );
  }

  Point _getCenter(Rect box) {
    return Point(box.left + (box.width / 2), box.top + (box.height / 2));
  }
}

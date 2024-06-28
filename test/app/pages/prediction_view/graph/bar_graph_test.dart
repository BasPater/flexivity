
import 'package:fl_chart/fl_chart.dart';
import 'package:flexivity/app/views/prediction_view/bar_graph/bar_graph.dart';
import 'package:flexivity/data/models/prediction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyBarGraph renders correctly', (WidgetTester tester) async {
    // Create a list of mock predictions
    final List<Prediction> mockPredictions = [
      Prediction(date: '2023-01-01', score: 1.0),
      Prediction(date: '2023-01-02', score: 2.0),
      Prediction(date: '2023-01-03', score: 3.0),
    ];

    // Build the MyBarGraph widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BarGraph(weeklySummery: mockPredictions),
        ),
      ),
    );

    // Let the widget finish any async work
    await tester.pumpAndSettle();

    // Check that the CircularProgressIndicator is not present
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Check that the BarChart is present
    expect(find.byType(BarChart), findsOneWidget);
  });
}
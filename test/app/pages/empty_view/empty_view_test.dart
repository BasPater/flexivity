import 'package:flexivity/app/views/empty_view/empty_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('EmptyView test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: EmptyView(
        text: 'Test',
        iconData: Icons.add,
      ),
    ));

    // Verify that our widget displays the correct text.
    expect(find.text('Test'), findsOneWidget);
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flexivity/app/widgets/navbar_widget.dart';

void main() {
  testWidgets('NavbarWidget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: NavbarWidget(index: 0),
      ),
    ));

    await tester.pumpAndSettle();

    // Verify that the NavbarWidget is displayed.
    expect(find.byType(NavbarWidget), findsOneWidget);

    // Verify that the home navigation button is displayed
    expect(find.text('Home'), findsOneWidget);
  });
}

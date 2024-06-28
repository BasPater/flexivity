import 'package:flexivity/app/views/start_view/start_view.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('StartView should be rendered', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: StartScreen()));

    // Verify that StartView is showing.
    expect(find.byType(StartScreen), findsOneWidget);

    // Verify that the "Sign up" button is showing.
    expect(find.widgetWithText(FullWidthButton, 'Sign up'), findsOneWidget);

    // Verify that the "Login" button is showing.
    expect(find.widgetWithText(TextButton, 'Login'), findsOneWidget);

    // Verify that the image is showing.
    expect(find.byType(Image), findsOneWidget);
  });
}

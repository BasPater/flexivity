import 'package:flexivity/app/views/profile_view/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileErrorView test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: ProfileErrorView(
        text: 'Error',
        onPressed: () {},
        iconData: Icons.error,
      ),
    ));

    // Verify that the error message is displayed.
    expect(find.text('Error'), findsOneWidget);

    // Verify that the logout button is displayed.
    expect(find.text('Log out'), findsOneWidget);

    // Tap the logout button and trigger a frame.
    await tester.tap(find.text('Log out'));
    await tester.pump();

    // Verify that the logout dialog is displayed.
    expect(find.text('Are you sure you want to log out?'), findsOneWidget);
  });
}

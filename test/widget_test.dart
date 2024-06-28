// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flexivity/main.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('MyApp widget is correctly built', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(routerConfig: GoRouter(routes: [])));

    // Verify that MyApp is in the widget tree.
    expect(find.byType(MyApp), findsOneWidget);
  });
}

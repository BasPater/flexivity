import 'package:flexivity/app/views/error_view/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('loading', () {
    testWidgets('Can load ', (tester) async {
      await tester.pumpWidget(MaterialApp(builder: (_, e) => ErrorView()));
      expect(
        find.byWidgetPredicate((widget) => widget is ErrorView),
        findsOneWidget,
      );
    });
  });

  group('optional widget', () {
    testWidgets('Can not show optional widget', (tester) async {
      await tester.pumpWidget(MaterialApp(builder: (_, e) => ErrorView()));
      final errorViewFinder = find.byWidgetPredicate(
        (widget) => widget is ErrorView,
      );
      
      final column = tester.widget(
        find.descendant(
          of: errorViewFinder,
          matching: find.byWidgetPredicate((widget) => widget is Column),
        ),
      ) as Column;

      expect(
        column.children.length,
        3,
      );
    });

    testWidgets('Can show optional widget', (tester) async {
      const placeHolder = Placeholder();
      await tester.pumpWidget(
        MaterialApp(
          builder: (_, e) => ErrorView(
            optionalWidget: placeHolder,
          ),
        ),
      );

      expect(find.byWidget(placeHolder), findsOne);
    });
  });
}

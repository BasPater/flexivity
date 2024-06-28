import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'UIStateSwitcher',
    () {
      testWidgets(
        'displays correct widget for normal state',
        (WidgetTester tester) async {
          UIState uiState = UIState.normal;

          await tester.pumpWidget(MaterialApp(
            home: UIStateSwitcher(
              uiState: uiState,
              normalState: const _NormalStateWidget(),
              errorState: const _ErrorStateWidget(),
              loadingState: const _LoadingStateWidget(),
              emptySate: const _ErrorStateWidget(),
            ),
          ));

          // Verify that the correct widget is displayed
          expect(find.byType(_NormalStateWidget), findsOneWidget);
        },
      );

      testWidgets(
        'displays correct widget for loading state',
        (WidgetTester tester) async {
          UIState uiState = UIState.loading;

          await tester.pumpWidget(MaterialApp(
            home: UIStateSwitcher(
              uiState: uiState,
              normalState: const _NormalStateWidget(),
              errorState: const _ErrorStateWidget(),
              loadingState: const _LoadingStateWidget(),
              emptySate: const _ErrorStateWidget(),
            ),
          ));

          // Verify that the correct widget is displayed
          expect(find.byType(_LoadingStateWidget), findsOneWidget);
        },
      );

      testWidgets('displays correct widget for error state',
          (WidgetTester tester) async {
        UIState uiState = UIState.error;

        await tester.pumpWidget(MaterialApp(
          home: UIStateSwitcher(
            uiState: uiState,
            normalState: const _NormalStateWidget(),
            errorState: const _ErrorStateWidget(),
            loadingState: const _LoadingStateWidget(),
            emptySate: const _EmptyStateWidget(),
          ),
        ));

        // Verify that the correct widget is displayed
        expect(find.byType(_ErrorStateWidget), findsOneWidget);
      });
    },
  );

  testWidgets(
    'displays correct widget for empty state',
    (WidgetTester tester) async {
      UIState uiState = UIState.empty;

      await tester.pumpWidget(MaterialApp(
        home: UIStateSwitcher(
          uiState: uiState,
          normalState: const _NormalStateWidget(),
          errorState: const _ErrorStateWidget(),
          loadingState: const _LoadingStateWidget(),
          emptySate: const _EmptyStateWidget(),
        ),
      ));

      // Verify that the correct widget is displayed
      expect(find.byType(_EmptyStateWidget), findsOneWidget);
    },
  );

  testWidgets(
    'displays correct widget for empty state when no empty state given',
    (WidgetTester tester) async {
      UIState uiState = UIState.empty;

      await tester.pumpWidget(MaterialApp(
        home: UIStateSwitcher(
          uiState: uiState,
          normalState: const _NormalStateWidget(),
          errorState: const _ErrorStateWidget(),
          loadingState: const _LoadingStateWidget(),
        ),
      ));

      // Verify that the correct widget is displayed
      expect(find.text('No data available'), findsOneWidget);
    },
  );

  testWidgets(
    'displays correct widget for error state when no error state given',
    (WidgetTester tester) async {
      UIState uiState = UIState.error;

      await tester.pumpWidget(MaterialApp(
        home: UIStateSwitcher(
          uiState: uiState,
          normalState: const _NormalStateWidget(),
          loadingState: const _LoadingStateWidget(),
        ),
      ));

      // Verify that the correct widget is displayed
      expect(find.text('An error occurred'), findsOneWidget);
    },
  );
}

class _ErrorStateWidget extends StatelessWidget {
  const _ErrorStateWidget();

  @override
  Widget build(BuildContext context) {
    return const Text('Error State');
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return const Text('Empty State');
  }
}

class _NormalStateWidget extends StatelessWidget {
  const _NormalStateWidget();

  @override
  Widget build(BuildContext context) {
    return const Text('Normal State');
  }
}

class _LoadingStateWidget extends StatelessWidget {
  const _LoadingStateWidget();

  @override
  Widget build(BuildContext context) {
    return const Text('Loading State');
  }
}

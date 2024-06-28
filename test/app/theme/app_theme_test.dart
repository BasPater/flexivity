import 'package:flexivity/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dark mode', () {
    test('Can create dark theme', () {
      final theme = FlexivityAppTheme.buildDarkTheme();
      expect(theme.brightness, Brightness.dark);
    });
  });

  group('Light theme', () {
    test('Can create light theme', () {
      final theme = FlexivityAppTheme.buildLightTheme();
      expect(theme.brightness, Brightness.light);
    });
  });
}

import 'package:flutter/material.dart';

class FlexivityAppTheme {
  static ThemeData buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2A02FF),
        primary: const Color(0xFF2A02FF),
        primaryContainer: const Color(0xFF9590F1),
        secondary: const Color(0xFF7974C6),
        brightness: Brightness.light,
      ),
      brightness: Brightness.light,
      useMaterial3: true,

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFE9E7FC),
        indicatorColor: const Color(0xFFD7D3F8),
      ),

      cardTheme: CardTheme(
        color: const Color(0xFFF2F0FF),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white
      ),


      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2A02FF),
        primary: const Color(0xFF9A91FF),
        secondary: const Color(0xFF554DF2),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
      brightness: Brightness.dark,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.black
      ),

      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black
      ),

      popupMenuTheme: PopupMenuThemeData(
          color: Colors.black
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

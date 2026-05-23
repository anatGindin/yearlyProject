import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.4.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// );
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static const Color _hamalBlue = Color.fromRGBO(54, 70, 121, 1.0);
  static const Color _happyBlue = Color.fromRGBO(102, 176, 250, 1.0);
  static ThemeData light = ThemeData(
    textTheme: GoogleFonts.heeboTextTheme(),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppTheme._hamalBlue,
      primary: _hamalBlue,
      primaryContainer: const Color.fromRGBO(221, 239, 255, 1.0),
      secondary: _happyBlue,
      tertiary: const Color.fromRGBO(0xE8, 0xF5, 0xFA, 1.0),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onTertiary: Colors.black,
    ),
    cardTheme: const CardThemeData(
      shadowColor: Color.fromRGBO(0, 0, 0, 0.8),
      elevation: 5,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.8),
        elevation: 5,
      ),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: _hamalBlue,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white.withAlpha(160),
      ),
    ),
    useMaterial3: true,
    brightness: Brightness.light,
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = ThemeData(
    textTheme: GoogleFonts.heeboTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: _happyBlue,
      brightness: Brightness.dark,
      primary: _happyBlue,
      surface: const Color(0xFF0F172A),
      surfaceContainer: const Color(0xFF1E293B),
      primaryContainer: Colors.black,
      secondary: _happyBlue,
      tertiary: const Color(0xFF334155),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onTertiary: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      shadowColor: Colors.black.withAlpha(120),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFF334155),
          width: 1,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.8),
        elevation: 5,
        foregroundColor: Colors.white,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color.fromRGBO(19, 37, 55, 1.0),
    ),
    appBarTheme: const AppBarThemeData(
      backgroundColor: Color(0xFF1E293B),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: _hamalBlue),
    ),
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}

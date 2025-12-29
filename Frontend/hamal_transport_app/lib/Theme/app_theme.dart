import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  static ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppTheme._hamalBlue,
      primary: Colors.black,
      secondary: AppTheme._hamalBlue,
      tertiary: const Color.fromRGBO(0, 174, 239, 1.0),
      onPrimary: const Color.fromRGBO(230, 230, 230, 1.0),
      surface: Colors.white,
      surfaceContainer: Colors.green,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _hamalBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
    cardTheme: const CardThemeData(
      shadowColor: Color.fromRGBO(0, 0, 0, 0.8),
      elevation: 5,
    ),
    useMaterial3: true,
    brightness: Brightness.light,
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Using FlexColorScheme built-in FlexScheme enum based colors.
    scheme: FlexScheme.blue,
    // Input color modifiers.
    swapLegacyOnMaterial3: true,
    swapColors: true,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}

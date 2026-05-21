import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Services/persistant_storagte_service.dart';

class AppPreferencesService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('he');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  Future<void> init() async {
    // Theme
    final savedTheme = await PersistentStorageService.getString(_themeKey);
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }

    // Locale
    final savedLanguage = await PersistentStorageService.getString(
      _languageKey,
    );
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
    }

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    await PersistentStorageService.setString(_themeKey, mode.name);
  }

  Future<void> updateLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();

    await PersistentStorageService.setString(_languageKey, locale.languageCode);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hamal_transport_app/Services/app_preferences_service.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';

class AppPreferencesView extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  final AppLocalizations l10n;
  final ThemeData theme;

  const AppPreferencesView({
    super.key,
    required this.onNavigate,
    required this.l10n,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppPreferencesService>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => onNavigate(0),
              ),
              Text(
                l10n.appPreferences,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 8),
              // Dark Mode Toggle
              SwitchListTile(
                title: Text(l10n.darkMode),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: settings.themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  settings.updateThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
              const Divider(),
              // Language Selection
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(l10n.language),
                trailing: DropdownButton<String>(
                  value: settings.locale.languageCode,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                    DropdownMenuItem(value: 'he', child: Text(l10n.hebrew)),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      settings.updateLocale(Locale(newValue));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

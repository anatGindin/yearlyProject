import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'Views/main_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Use MediaQuery builder to scale all text globally (avoids TextStyle.apply assertion)
      builder: (BuildContext context, Widget? child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: const TextScaler.linear(1.4)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const MainPage(),
    );
  }
}

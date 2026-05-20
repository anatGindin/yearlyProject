import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'Views/Authentication/auth_gate.dart';
import 'Services/location_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:hamal_transport_app/firebase_options.dart';
import 'package:hamal_transport_app/Theme/app_theme.dart';
import 'package:hamal_transport_app/Services/app_preferences_service.dart';
import 'package:hamal_transport_app/Services/navigation_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // TODO: Change this once you publish the app. It should be the play integrity default provider.
  await FirebaseAppCheck.instance.activate(
    // Set androidProvider to `AndroidProvider.debug`
    providerAndroid: const AndroidDebugProvider(),
  );
  await initializeMockData();

  final prefsService = AppPreferencesService();
  await prefsService.init();

  runApp(MyApp(prefsService: prefsService));
}

class MyApp extends StatelessWidget {
  final AppPreferencesService prefsService;

  const MyApp({super.key, required this.prefsService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppPreferencesService>.value(
          value: prefsService,
        ),
        Provider<AuthenticationService>(create: (_) => AuthenticationService()),
        ChangeNotifierProvider<MissionsRepository>(
          create: (context) => MissionsRepository(),
        ),

        Provider<LocationService>(create: (_) => LocationService()),
        ChangeNotifierProvider<MainNavigationController>(
          create: (_) => MainNavigationController(),
        ),
      ],
      child: Consumer<AppPreferencesService>(
        builder: (context, settings, _) {
          return MaterialApp(
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: settings.locale,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            builder: (BuildContext context, Widget? child) {
              final mq = MediaQuery.of(context);
              return MediaQuery(
                data: mq.copyWith(textScaler: const TextScaler.linear(1.4)),
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

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
import 'package:hamal_transport_app/firebase_options.dart';
import 'package:hamal_transport_app/Theme/app_theme.dart';
import 'package:hamal_transport_app/Services/app_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeMockData();

  final prefsService = AppPreferencesService();
  await prefsService.init();

  // Initialize MissionsRepository singleton with data before app starts
  MissionsRepository(
    myMissionsList: sampleMissions,
    availableMissionsList: availableMissions,
    authService: AuthenticationService(),
  );

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
        ChangeNotifierProxyProvider<AuthenticationService, MissionsRepository>(
          create: (context) => MissionsRepository(
            authService: context.read<AuthenticationService>(),
          ),
          update: (context, authService, previous) {
            if (previous == null) {
              final repo = MissionsRepository(authService: authService);
              return repo;
            }
            return previous;
          },
        ),

        Provider<LocationService>(create: (_) => LocationService()),
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

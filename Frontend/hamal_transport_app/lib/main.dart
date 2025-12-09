import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:hamal_transport_app/ViewModels/missions_coordinator_view_model.dart';
import 'package:hamal_transport_app/ViewModels/my_missions_view_model.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'Views/Authentication/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hamal_transport_app/firebase_options.dart';
import 'Views/main_page.dart';
import 'Theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => MissionsListsModel(
            myMissionsList: sampleMissions,
            availableMissionsList: availableMissions,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              MyMissionsViewModel(context.read<MissionsListsModel>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AvailableMissionsViewModel(context.read<MissionsListsModel>()),
        ),
        Provider(
          create: (context) => MissionsCoordinatorViewModel(
            myMissionsVM: context.read<MyMissionsViewModel>(),
            availableMissionsVM: context.read<AvailableMissionsViewModel>(),
          ),
        ),
      ],
      child: MaterialApp(
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
        home: const AuthGate(),
      ),
    );
  }
}

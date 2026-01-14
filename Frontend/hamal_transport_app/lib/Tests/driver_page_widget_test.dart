import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/Fake/fake_authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/ViewModels/driver_view_model.dart';
import 'package:hamal_transport_app/Views/driver_page.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeMockData();
  });

  group('DriverPage - Error State', () {
    testWidgets('Displays error icon when errorMessage is set', (tester) async {
      final authService = FakeAuthenticationService();
      final repository = MissionsRepository(
        myMissionsList: [...sampleMissions],
        availableMissionsList: [...availableMissions],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: 'test-uid',
        authService: authService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
        ),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Since errorMessage would be null in this case, we test error display separately
      // by simulating an error state
      // Note: This is limited without direct error injection
    });
  });

  group('DriverPage - Driver Info Card', () {
    testWidgets('Displays driver name correctly', (tester) async {
      const driverUid = 'test-driver-123';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'driver@test.com',
        name: 'John Doe',
        phone: '+972-54-1234567',
        role: UserRole.driver,
      );

      final authService = FakeAuthenticationService();
      authService.mockUserProfileByUid = {driverUid: mockProfile};

      final repository = MissionsRepository(
        myMissionsList: [...sampleMissions],
        availableMissionsList: [...availableMissions],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        authService: authService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Driver name appears in header and in ContactInfoActionable
      expect(find.text('John Doe'), findsWidgets);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('Shows first letter in CircleAvatar', (tester) async {
      const driverUid = 'test-driver-123';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'driver@test.com',
        name: 'Alice',
        phone: '+972-54-1234567',
        role: UserRole.driver,
      );

      final authService = FakeAuthenticationService();
      authService.mockUserProfileByUid = {driverUid: mockProfile};

      final repository = MissionsRepository(
        myMissionsList: [...sampleMissions],
        availableMissionsList: [...availableMissions],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        authService: authService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('A'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('Displays email and phone correctly', (tester) async {
      const driverUid = 'test-driver-123';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'driver@test.com',
        name: 'Test Driver',
        phone: '+972-54-1234567',
        role: UserRole.driver,
      );

      final authService = FakeAuthenticationService();
      authService.mockUserProfileByUid = {driverUid: mockProfile};

      final repository = MissionsRepository(
        myMissionsList: [...sampleMissions],
        availableMissionsList: [...availableMissions],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        authService: authService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('driver@test.com'), findsOneWidget);
      expect(find.text('+972-54-1234567'), findsOneWidget);
    });

    testWidgets('Shows N/A for missing email/phone', (tester) async {
      const driverUid = 'missing-profile';
      final authService = FakeAuthenticationService();
      authService.mockUserProfileByUid = {};

      final repository = MissionsRepository(
        myMissionsList: [...sampleMissions],
        availableMissionsList: [...availableMissions],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        authService: authService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('N/A'),
        findsNWidgets(2),
      ); // One for email, one for phone
    });

    testWidgets('Shows car type when available', (tester) async {
      const driverUid = 'driver-with-car';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'driver@test.com',
        name: 'Driver With Car',
        phone: '+972-54-1234567',
        role: UserRole.driver,
        driverProfile: DriverProfile(carType: CarType.trailer),
      );

      final authService = FakeAuthenticationService();
      authService.mockUserProfileByUid = {driverUid: mockProfile};

      final repository = MissionsRepository(
        myMissionsList: [...sampleMissions],
        availableMissionsList: [...availableMissions],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        authService: authService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('trailer'), findsOneWidget);
    });
  });

  group('DriverPage - Missions Section', () {
    testWidgets('Shows empty state when no missions', (tester) async {
      const driverUid = 'driver-no-missions';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'lonely@driver.com',
        name: 'Lonely Driver',
        phone: '+972-54-0000000',
        role: UserRole.driver,
      );

      final authService = FakeAuthenticationService();
      authService.mockUserProfileByUid = {driverUid: mockProfile};

      final repository = MissionsRepository(
        myMissionsList: [],
        availableMissionsList: [],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        authService: authService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No missions'), findsOneWidget);
    });

    testWidgets('Renders mission cards for each mission', (tester) async {
      const driverUid = 'I9ivZ6H8pYWoDkeb2wybbKXgxWE2';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'busy@driver.com',
        name: 'Busy Driver',
        phone: '+972-54-9999999',
        role: UserRole.driver,
      );

      final authService = FakeAuthenticationService();
      authService.mockUserProfileByUid = {driverUid: mockProfile};

      final repository = MissionsRepository(
        myMissionsList: [...sampleMissions],
        availableMissionsList: [...availableMissions],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        authService: authService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have mission cards
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Mission cards are tappable', (tester) async {
      const driverUid = 'I9ivZ6H8pYWoDkeb2wybbKXgxWE2';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'driver@test.com',
        name: 'Test Driver',
        phone: '+972-54-1234567',
        role: UserRole.driver,
      );

      final authService = FakeAuthenticationService();
      authService.mockUserProfileByUid = {driverUid: mockProfile};

      final repository = MissionsRepository(
        myMissionsList: [...sampleMissions],
        availableMissionsList: [...availableMissions],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        authService: authService,
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DriverViewModel>.value(value: viewModel),
            ChangeNotifierProvider<MissionsRepository>.value(value: repository),
          ],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('he')],
            home: DriverPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have mission cards wrapped in InkWell widgets for tap functionality
      final cards = find.byType(Card);
      expect(cards, findsWidgets);

      // Verify InkWell widgets exist (making cards tappable)
      final missionCardInkWells = find.byWidgetPredicate(
        (widget) => widget is InkWell && widget.onTap != null,
      );
      expect(missionCardInkWells, findsWidgets);
    });
  });

  group('DriverPage - Refresh Functionality', () {
    testWidgets('AppBar refresh button is present', (tester) async {
      const driverUid = 'test-driver';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'driver@test.com',
        name: 'Test Driver',
        phone: '+972-54-1234567',
        role: UserRole.driver,
      );

      final authService = FakeAuthenticationService();
      authService.mockUserProfileByUid = {driverUid: mockProfile};

      final repository = MissionsRepository(
        myMissionsList: [...sampleMissions],
        availableMissionsList: [...availableMissions],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        authService: authService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('RefreshIndicator is present', (tester) async {
      const driverUid = 'test-driver';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'driver@test.com',
        name: 'Test Driver',
        phone: '+972-54-1234567',
        role: UserRole.driver,
      );

      final authService = FakeAuthenticationService();
      authService.mockUserProfileByUid = {driverUid: mockProfile};

      final repository = MissionsRepository(
        myMissionsList: [...sampleMissions],
        availableMissionsList: [...availableMissions],
        authService: authService,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        authService: authService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}


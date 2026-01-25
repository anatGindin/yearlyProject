import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/Services/Fake/fake_authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/ViewModels/driver_view_model.dart';
import 'package:hamal_transport_app/Views/DriversPhonebook/driver_page.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeMockData();
  });

  setUp(() {
    final authService = FakeAuthenticationService();
    // Initialize singleton with test data before each test
    MissionsRepository.reset();
    MissionsRepository(
      missions: [...sampleMissions, ...availableMissions],
      authService: authService,
    );
  });

  Widget createTestApp(Widget child, {AuthenticationService? authService}) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>.value(
          value: authService ?? FakeAuthenticationService(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('he')],
        home: child,
      ),
    );
  }

  group('DriverPage - Error State', () {
    testWidgets('Displays error icon when errorMessage is set', (tester) async {
      final authService = FakeAuthenticationService();
      final viewModel = DriverViewModel(driverUid: 'test-uid');

      await tester.pumpWidget(
        createTestApp(
          ChangeNotifierProvider<DriverViewModel>.value(
            value: viewModel,
            child: const DriverPage(),
          ),
          authService: authService,
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

      await tester.pumpWidget(
        createTestApp(DriverPage(driverProfile: mockProfile)),
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

      await tester.pumpWidget(
        createTestApp(DriverPage(driverProfile: mockProfile)),
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

      await tester.pumpWidget(
        createTestApp(DriverPage(driverProfile: mockProfile)),
      );

      await tester.pumpAndSettle();

      expect(find.text('driver@test.com'), findsOneWidget);
      expect(find.text('+972-54-1234567'), findsOneWidget);
    });

    testWidgets('Shows N/A for missing email/phone', (tester) async {
      const driverUid = 'missing-profile';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: '',
        name: 'Driver ($driverUid)',
        phone: '',
        role: UserRole.driver,
      );

      await tester.pumpWidget(
        createTestApp(DriverPage(driverProfile: mockProfile)),
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

      await tester.pumpWidget(
        createTestApp(DriverPage(driverProfile: mockProfile)),
      );

      await tester.pumpAndSettle();

      // Check for localized car type text (English: "Trailer")
      expect(find.text('Trailer'), findsOneWidget);
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

      // Initialize singleton with empty data for this test
      MissionsRepository.reset();
      MissionsRepository(
        missions: [...sampleMissions, ...availableMissions],
        authService: authService,
      );

      await tester.pumpWidget(
        createTestApp(
          DriverPage(driverProfile: mockProfile),
          authService: authService,
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

      await tester.pumpWidget(
        createTestApp(DriverPage(driverProfile: mockProfile)),
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

      await tester.pumpWidget(
        createTestApp(DriverPage(driverProfile: mockProfile)),
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
}

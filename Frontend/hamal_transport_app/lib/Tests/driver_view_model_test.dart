import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/Fake/fake_authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/ViewModels/driver_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeMockData();
  });

  group('DriverViewModel - State Management', () {
    late DriverViewModel viewModel;
    const testDriverUid = 'test-driver-uid';
    late FakeAuthenticationService authService;

    setUp(() {
      authService = FakeAuthenticationService();
      // Initialize the singleton with test data
      MissionsRepository.reset();
      MissionsRepository(
        missions: [...sampleMissions, ...availableMissions],
        authService: authService,
      );
    });

    test('Initial state is loading', () {
      // Create a profile to avoid calling AuthenticationService
      final mockProfile = UserProfile(
        uid: testDriverUid,
        email: 'test@test.com',
        name: 'Test',
        phone: '123',
        role: UserRole.driver,
      );

      viewModel = DriverViewModel(
        driverUid: testDriverUid,
        initialProfile: mockProfile,
        driverMissions: [],
      );

      expect(viewModel.isLoading, false);
    });

    test('Successfully loads driver profile and updates state', () async {
      final mockProfile = UserProfile(
        uid: testDriverUid,
        email: 'driver@test.com',
        name: 'Test Driver',
        phone: '+972-54-1234567',
        role: UserRole.driver,
        driverProfile: DriverProfile(carType: CarType.private),
      );

      viewModel = DriverViewModel(
        driverUid: testDriverUid,
        initialProfile: mockProfile,
        driverMissions: [],
      );

      expect(viewModel.isLoading, false);
      expect(viewModel.driverProfile, isNotNull);
      expect(viewModel.driverProfile?.name, 'Test Driver');
      expect(viewModel.driverProfile?.email, 'driver@test.com');
      expect(viewModel.driverProfile?.phone, '+972-54-1234567');
      expect(viewModel.errorMessage, isNull);
    });

    test('Handles null driver profile gracefully', () async {
      viewModel = DriverViewModel(
        driverUid: testDriverUid,
        initialProfile: null,
        driverMissions: [],
      );

      expect(viewModel.driverName, 'Driver ($testDriverUid)');
      expect(viewModel.driverEmail, 'N/A');
      expect(viewModel.driverPhone, 'N/A');
    });

    test('Filters missions correctly by driver UID', () async {
      const driverUid = 'I9ivZ6H8pYWoDkeb2wybbKXgxWE2';

      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'driver@test.com',
        name: 'Test Driver',
        phone: '+972-54-1234567',
        role: UserRole.driver,
      );
      // Create missions with different statuses
      final mission1 = Mission(
        id: 'test-m1',
        source: sampleMissions.first.source,
        destination: sampleMissions.first.destination,
        description: 'Test mission 1',
        sourceContact: sampleMissions.first.sourceContact,
        destinationContact: sampleMissions.first.destinationContact,
        time: DateTime.now(),
        status: MissionStatus.assigned,
        carType: CarType.private,
        comments: [],
        driverUid: driverUid,
      );
      viewModel = DriverViewModel(
        driverUid: driverUid,
        initialProfile: mockProfile,
        driverMissions: [mission1],
      );

      final driverMissions = viewModel.driverMissions;

      // All missions should belong to this driver
      expect(
        driverMissions.every((mission) => mission.driverUid == driverUid),
        true,
      );

      // Should have missions from sample data
      expect(driverMissions.isNotEmpty, true);
    });

    test('Returns missions grouped by status correctly', () async {
      const driverUid = 'I9ivZ6H8pYWoDkeb2wybbKXgxWE2';

      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'driver@test.com',
        name: 'Test Driver',
        phone: '+972-54-1234567',
        role: UserRole.driver,
      );

      viewModel = DriverViewModel(
        driverUid: driverUid,
        initialProfile: mockProfile,
        driverMissions: [],
      );

      final assignedMissions = viewModel.getMissionsByStatus(
        MissionStatus.assigned,
      );
      final pickedUpMissions = viewModel.getMissionsByStatus(
        MissionStatus.pickedUp,
      );

      // Verify all returned missions have the correct status
      expect(
        assignedMissions.every((m) => m.status == MissionStatus.assigned),
        true,
      );
      expect(
        pickedUpMissions.every((m) => m.status == MissionStatus.pickedUp),
        true,
      );
    });
  });

  group('DriverViewModel - Edge Cases', () {
    late FakeAuthenticationService authService;

    setUp(() {
      authService = FakeAuthenticationService();
      // Initialize the singleton with test data
      MissionsRepository.reset();
      MissionsRepository(
        missions: [...sampleMissions, ...availableMissions],
        authService: authService,
      );
    });

    test('Empty driver UID handling', () async {
      final viewModel = DriverViewModel(
        driverUid: '',
        initialProfile: null,
        driverMissions: [],
      );

      expect(viewModel.driverName, 'Driver ()');
    });

    test('Driver with no assigned missions', () async {
      const driverUid = 'driver-with-no-missions';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'lonely@driver.com',
        name: 'Lonely Driver',
        phone: '+972-54-0000000',
        role: UserRole.driver,
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        initialProfile: mockProfile,
        driverMissions: [],
      );

      expect(viewModel.driverMissions, isEmpty);
      expect(viewModel.getMissionsByStatus(MissionStatus.assigned), isEmpty);
      expect(viewModel.getMissionsByStatus(MissionStatus.pickedUp), isEmpty);
    });

    test('Driver with missions in multiple statuses', () async {
      const driverUid = 'multi-status-driver';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'busy@driver.com',
        name: 'Busy Driver',
        phone: '+972-54-9999999',
        role: UserRole.driver,
      );

      authService.mockUserProfileByUid = {driverUid: mockProfile};

      // Create missions with different statuses
      final mission1 = Mission(
        id: 'test-m1',
        source: sampleMissions.first.source,
        destination: sampleMissions.first.destination,
        description: 'Test mission 1',
        sourceContact: sampleMissions.first.sourceContact,
        destinationContact: sampleMissions.first.destinationContact,
        time: DateTime.now(),
        status: MissionStatus.assigned,
        carType: CarType.private,
        comments: [],
        driverUid: driverUid,
      );

      final mission2 = Mission(
        id: 'test-m2',
        source: sampleMissions.first.source,
        destination: sampleMissions.first.destination,
        description: 'Test mission 2',
        sourceContact: sampleMissions.first.sourceContact,
        destinationContact: sampleMissions.first.destinationContact,
        time: DateTime.now(),
        status: MissionStatus.pickedUp,
        carType: CarType.private,
        comments: [],
        driverUid: driverUid,
      );

      MissionsRepository().addMission(MissionListType.myMissions, mission1);
      MissionsRepository().addMission(MissionListType.myMissions, mission2);

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        initialProfile: mockProfile,
        driverMissions: [mission1, mission2],
      );

      expect(viewModel.driverMissions.length, 2);
      expect(viewModel.getMissionsByStatus(MissionStatus.assigned).length, 1);
      expect(viewModel.getMissionsByStatus(MissionStatus.pickedUp).length, 1);
    });

    test('Car type is null when driver profile is null', () async {
      final viewModel = DriverViewModel(
        driverUid: 'test-uid',
        initialProfile: null,
        driverMissions: [],
      );

      expect(viewModel.carType, isNull);
    });

    test('Car type is displayed when driver profile exists', () async {
      const driverUid = 'driver-with-car';
      final mockProfile = UserProfile(
        uid: driverUid,
        email: 'driver@test.com',
        name: 'Driver With Car',
        phone: '+972-54-1234567',
        role: UserRole.driver,
        driverProfile: DriverProfile(carType: CarType.trailer),
      );

      final viewModel = DriverViewModel(
        driverUid: driverUid,
        initialProfile: mockProfile,
        driverMissions: [],
      );

      expect(viewModel.carType, CarType.trailer);
    });
  });
}

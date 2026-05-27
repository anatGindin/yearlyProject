import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/Fake/fake_authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/ViewModels/missions_list_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockUser extends Mock implements User {
  @override
  final String uid;

  MockUser({required this.uid});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize mock data before running any tests
  setUpAll(() async {
    await initializeMockData();
  });

  group('MissionsRepository - Use Cases', () {
    late MissionsRepository repository;
    late MissionsListViewModel availableVM;
    late MissionsListViewModel myVM;

    // Note: MissionViewModel might not be strictly needed for these repo tests,
    // but useful if we want to simulate VM behavior or if tests relied on it.
    // Ideally we test the Repository's effect on the data.

    late Mission testMission;

    setUp(() async {
      // Reset mock data to ensure clean state for each test
      await initializeMockData();

      // create data model
      final authService = FakeAuthenticationService();
      authService.mockUser = MockUser(uid: 'test-user-uid');

      // Update sample missions to match the mock user for "My Missions" tests
      for (var m in sampleMissions) {
        m.driverUid = 'test-user-uid';
        m.status = MissionStatus.assigned;
      }

      MissionsRepository.reset();
      repository = MissionsRepository(
        authService: authService,
        missions: [...sampleMissions, ...availableMissions],
      );

      // Create ViewModels with initial state
      availableVM = MissionsListViewModel(
        type: MissionListType.availableMissions,
        role: UserRole.driver,
      );
      myVM = MissionsListViewModel(
        type: MissionListType.myMissions,
        role: UserRole.driver,
      );
    });

    test('takeMission moves mission from available -> my missions', () {
      testMission = repository
          .getMissions(MissionListType.availableMissions)
          .first;
      int initialAvailableLength = repository
          .getMissions(MissionListType.availableMissions)
          .length;
      int initialMyLength = repository
          .getMissions(MissionListType.myMissions)
          .length;

      // Verify initial state
      // We can check via VM or Repo. VM just exposes Repo data.
      expect(availableVM.sourceList.length, initialAvailableLength);
      expect(myVM.sourceList.length, initialMyLength);
      expect(testMission.status, MissionStatus.available);

      // Perform action
      repository.takeMission(testMission);

      // Verify mission moved lists
      expect(availableVM.sourceList.length, initialAvailableLength - 1);
      expect(myVM.sourceList.length, initialMyLength + 1);
      expect(myVM.sourceList.contains(testMission), true);

      // Verify status updated
      expect(testMission.status, MissionStatus.assigned);
    });

    test('updateStatus to delivered removes mission from my missions', () {
      // Setup: ensure we have a mission in my missions
      if (repository.getMissions(MissionListType.myMissions).isEmpty) {
        // Should have some from mock data, but let's be safe or just use one.
        // sampleMissions is not empty in mock_data.
      }
      testMission = repository.getMissions(MissionListType.myMissions).first;

      // Ensure it is 'assigned' or 'pickedUp' initially
      testMission.status = MissionStatus.assigned;

      int initialMyLength = repository
          .getMissions(MissionListType.myMissions)
          .length;

      // Verify initial state
      expect(myVM.sourceList.contains(testMission), true);

      // Perform action
      repository.updateStatus(testMission, MissionStatus.delivered);

      // Verify mission removed from my missions
      expect(myVM.sourceList.length, initialMyLength - 1);
      expect(myVM.sourceList.contains(testMission), false);

      // Verify status updated
      expect(testMission.status, MissionStatus.delivered);
    });

    test('cancelMission returns mission to available', () {
      // Setup: use a mission from my missions
      testMission = repository.getMissions(MissionListType.myMissions).first;
      testMission.status = MissionStatus.assigned;

      int initialAvailableLength = repository
          .getMissions(MissionListType.availableMissions)
          .length;
      int initialMyLength = repository
          .getMissions(MissionListType.myMissions)
          .length;

      // Perform action
      repository.cancelMission(testMission, "cancellationReason");

      // Verify mission moved back to available
      expect(availableVM.sourceList.length, initialAvailableLength + 1);
      expect(myVM.sourceList.length, initialMyLength - 1);
      expect(availableVM.sourceList.contains(testMission), true);
      expect(myVM.sourceList.contains(testMission), false);

      // Verify status updated to available (not cancelled status, but available list)
      expect(testMission.status, MissionStatus.available);
      expect(testMission.cancellationReason, "cancellationReason");
    });

    test('abandonMission moves mission from my missions -> available', () {
      // Setup: use a mission from my missions
      testMission = repository.getMissions(MissionListType.myMissions).first;
      testMission.status = MissionStatus.assigned;

      int initialAvailableLength = repository
          .getMissions(MissionListType.availableMissions)
          .length;
      int initialMyLength = repository
          .getMissions(MissionListType.myMissions)
          .length;

      // Perform action
      repository.abandonMission(testMission);

      // Verify mission moved lists
      expect(availableVM.sourceList.length, initialAvailableLength + 1);
      expect(myVM.sourceList.length, initialMyLength - 1);
      expect(availableVM.sourceList.contains(testMission), true);

      expect(testMission.status, MissionStatus.available);
    });
  });
}

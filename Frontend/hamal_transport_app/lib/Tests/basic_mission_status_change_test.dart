import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:hamal_transport_app/ViewModels/mission_view_model.dart';
import 'package:hamal_transport_app/ViewModels/my_missions_view_model.dart';
import 'package:hamal_transport_app/ViewModels/missions_coordinator_view_model.dart';

void main() {
  group('MissionsCoordinatorViewModel - takeMission', () {
    late MissionsListsModel missionsLists;
    late AvailableMissionsViewModel availableVM;
    late MyMissionsViewModel myVM;
    late MissionViewModel missionVM;
    late MissionsCoordinatorViewModel coordinator;

    late Mission testMission;

    setUp(() {
      // create data model
      missionsLists = MissionsListsModel(
        myMissionsList: sampleMissions,
        availableMissionsList: availableMissions,
      );

      // Create ViewModels with initial state
      availableVM = AvailableMissionsViewModel(missionsLists);
      myVM = MyMissionsViewModel(missionsLists);
      missionVM = MissionViewModel();

      // Coordinator under test
      coordinator = MissionsCoordinatorViewModel(
        myMissionsVM: myVM,
        availableMissionsVM: availableVM,
        missionVM: missionVM,
      );
    });

    test('takeMission moves mission from available → my missions', () {
      testMission = availableMissions[0];
      int initialAvailableLength = availableMissions.length;
      int initialMyLength = sampleMissions.length;

      // Verify initial state
      expect(availableVM.availableMissions.length, initialAvailableLength);
      expect(myVM.myMissions.length, initialMyLength);
      expect(testMission.status, 'available');

      // Perform action
      coordinator.takeMission(testMission);

      // Verify mission moved lists
      expect(availableVM.availableMissions.length, initialAvailableLength - 1);
      expect(myVM.myMissions.length, initialMyLength + 1);
      expect(myVM.myMissions.last, testMission);

      // Verify status updated
      expect(testMission.status, 'chosen');
    });
  });

  group('MissionsCoordinatorViewModel - abandonMission', () {
    late MissionsListsModel missionsLists;
    late AvailableMissionsViewModel availableVM;
    late MyMissionsViewModel myVM;
    late MissionViewModel missionVM;
    late MissionsCoordinatorViewModel coordinator;

    late Mission testMission;

    setUp(() {
      // create data model
      missionsLists = MissionsListsModel(
        myMissionsList: sampleMissions,
        availableMissionsList: availableMissions,
      );

      // Create ViewModels with initial state
      availableVM = AvailableMissionsViewModel(missionsLists);
      myVM = MyMissionsViewModel(missionsLists);
      missionVM = MissionViewModel();

      // Coordinator under test
      coordinator = MissionsCoordinatorViewModel(
        myMissionsVM: myVM,
        availableMissionsVM: availableVM,
        missionVM: missionVM,
      );
    });

    test('abandonMission moves mission from my missions → available', () {
      testMission = sampleMissions[0];
      int initialAvailableLength = availableMissions.length;
      int initialMyLength = sampleMissions.length;

      // Verify initial state
      expect(availableVM.availableMissions.length, initialAvailableLength);
      expect(myVM.myMissions.length, initialMyLength);
      expect(testMission.status, 'available');

      // Perform action
      coordinator.abandonMission(testMission);

      // Verify mission moved lists
      expect(availableVM.availableMissions.length, initialAvailableLength + 1);
      expect(myVM.myMissions.length, initialMyLength - 1);
      expect(availableVM.availableMissions.last, testMission);

      // Verify status updated
      expect(testMission.status, 'available');
    });
  });
}

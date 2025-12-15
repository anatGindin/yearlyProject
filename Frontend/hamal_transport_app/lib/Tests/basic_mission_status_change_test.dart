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
      missionVM = MissionViewModel(availableMissions[0]);

      // Coordinator under test
      coordinator = MissionsCoordinatorViewModel(
        myMissionsVM: myVM,
        availableMissionsVM: availableVM,
      );
    });

    test('takeMission moves mission from available → my missions', () {
      coordinator.setMissionVM(missionVM);
      testMission = availableMissions[0];
      int initialAvailableLength = availableMissions.length;
      int initialMyLength = sampleMissions.length;

      // Verify initial state
      expect(availableVM.availableMissions.length, initialAvailableLength);
      expect(myVM.myMissions.length, initialMyLength);
      expect(testMission.status, MissionStatus.available);

      // Perform action
      coordinator.takeMission(testMission);

      // Verify mission moved lists
      expect(availableVM.availableMissions.length, initialAvailableLength - 1);
      expect(myVM.myMissions.length, initialMyLength + 1);
      expect(myVM.myMissions.contains(testMission), true);

      // Verify status updated
      expect(testMission.status, MissionStatus.chosen);
    });
  });

  group('MissionsCoordinatorViewModel - updateStatus', () {
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
      missionVM = MissionViewModel(sampleMissions[0]);

      // Coordinator under test
      coordinator = MissionsCoordinatorViewModel(
        myMissionsVM: myVM,
        availableMissionsVM: availableVM,
      );
    });

    test('updateStatus to delivered removes mission from my missions', () {
      coordinator.setMissionVM(missionVM);
      testMission = sampleMissions[0];
      int initialMyLength = sampleMissions.length;

      // Verify initial state
      expect(myVM.myMissions.length, initialMyLength);
      expect(testMission.status, MissionStatus.chosen);
      expect(myVM.myMissions.contains(testMission), true);

      // Perform action
      coordinator.updateStatus(testMission, MissionStatus.delivered);

      // Verify mission removed from my missions
      expect(myVM.myMissions.length, initialMyLength - 1);
      expect(myVM.myMissions.contains(testMission), false);

      // Verify status updated
      expect(testMission.status, MissionStatus.delivered);
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
      missionVM = MissionViewModel(sampleMissions[0]);

      // Coordinator under test
      coordinator = MissionsCoordinatorViewModel(
        myMissionsVM: myVM,
        availableMissionsVM: availableVM,
      );
    });

    test('abandonMission moves mission from my missions → available', () {
      coordinator.setMissionVM(missionVM);
      testMission = sampleMissions[0];
      int initialAvailableLength = availableMissions.length;
      int initialMyLength = sampleMissions.length;

      // Verify initial state
      expect(availableVM.availableMissions.length, initialAvailableLength);
      expect(myVM.myMissions.length, initialMyLength);
      expect(testMission.status, MissionStatus.chosen);

      // Perform action
      coordinator.abandonMission(testMission);

      // Verify mission moved lists
      expect(availableVM.availableMissions.length, initialAvailableLength + 1);
      expect(myVM.myMissions.length, initialMyLength - 1);
      expect(availableVM.availableMissions.contains(testMission), true);

      // Note: abandonMission doesn't update status, only moves between lists
      // Status remains 'chosen' - use updateStatus('cancelled') to also change status
      expect(testMission.status, MissionStatus.available);
    });
  });
}

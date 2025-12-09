import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:hamal_transport_app/ViewModels/mission_view_model.dart';
import 'package:hamal_transport_app/ViewModels/my_missions_view_model.dart';

class MissionsCoordinatorViewModel {
  final MyMissionsViewModel myMissionsVM;
  final AvailableMissionsViewModel availableMissionsVM;
  late MissionViewModel missionVM;

  MissionsCoordinatorViewModel({
    required this.myMissionsVM,
    required this.availableMissionsVM,
  });

  void setMissionVM(MissionViewModel missionVM) {
    this.missionVM = missionVM;
  }

  /// Move mission from Available → My Missions
  void takeMission(Mission mission) {
    missionVM.updateStatus('chosen');
    availableMissionsVM.remove(mission);
    myMissionsVM.add(mission);
  }

  /// Move mission from My → Available Missions
  void abandonMission(Mission mission) {
    myMissionsVM.remove(mission);
    availableMissionsVM.add(mission);
  }

  void updateStatus(Mission mission, String newStatus) {
    if (newStatus == 'cancelled') {
      abandonMission(mission);
      newStatus = 'available';
    } else if (newStatus == 'delivered') {
      myMissionsVM.remove(mission);
    }
    missionVM.updateStatus(newStatus);
  }

  bool isAvailable(Mission mission) {
    return availableMissionsVM.availableMissions.contains(mission) &&
        mission.status == 'available';
  }
}

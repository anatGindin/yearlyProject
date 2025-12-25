import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:hamal_transport_app/ViewModels/mission_view_model.dart';
import 'package:hamal_transport_app/ViewModels/my_missions_view_model.dart';

class MissionsCoordinatorViewModel extends ChangeNotifier {
  final MyMissionsViewModel myMissionsVM;
  final AvailableMissionsViewModel availableMissionsVM;
  late MissionViewModel missionVM;

  MissionsCoordinatorViewModel({
    required this.myMissionsVM,
    required this.availableMissionsVM,
  }) {
    myMissionsVM.addListener(notifyListeners);
    availableMissionsVM.addListener(notifyListeners);
  }

  @override
  void dispose() {
    myMissionsVM.removeListener(notifyListeners);
    availableMissionsVM.removeListener(notifyListeners);
    super.dispose();
  }

  void setMissionVM(MissionViewModel missionVM) {
    this.missionVM = missionVM;
  }

  /// Move mission from Available → My Missions
  void takeMission(Mission mission) {
    missionVM.updateStatus(MissionStatus.chosen);
    availableMissionsVM.remove(mission);
    myMissionsVM.add(mission);
  }

  /// Move mission from My → Available Missions
  void abandonMission(Mission mission) {
    myMissionsVM.remove(mission);
    availableMissionsVM.add(mission);
    missionVM.updateStatus(MissionStatus.available);
  }

  void updateStatus(Mission mission, MissionStatus newStatus) {
    if (newStatus == MissionStatus.delivered) {
      myMissionsVM.remove(mission);
    }
    MissionStatus oldStatus = mission.status;

    missionVM.updateStatus(newStatus);
    if (oldStatus != MissionStatus.available) {
      myMissionsVM.updateStatusChanged();
    }
  }

  void cancelMission(String cancellationReason) {
    abandonMission(missionVM.mission);
    missionVM.cancelMission(cancellationReason);
  }

  bool isAvailable(Mission mission) {
    return availableMissionsVM.availableMissions.contains(mission) &&
        mission.status == MissionStatus.available;
  }
}

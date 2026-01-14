import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';

class MissionsRepository extends ChangeNotifier {
  final List<Mission> _allMissions;
  final AuthenticationService authService;

  MissionsRepository({required this.authService})
    // TODO: Fetch missions from backend
    : _allMissions = [
        ...sampleMissions,
        ...availableMissions,
        ...adminMissions,
      ];

  List<Mission> getMissions(MissionListType type) {
    switch (type) {
      case MissionListType.myMissions:
        return _allMissions.where((mission) {
          return mission.driverUid == authService.currentUser?.uid &&
              mission.status != MissionStatus.delivered;
        }).toList();
      case MissionListType.availableMissions:
        return _allMissions
            .where((mission) => mission.status == MissionStatus.available)
            .toList();
      case MissionListType.allMissions:
        return _allMissions;
      case MissionListType.assignedMissions:
        return _allMissions
            .where((mission) => mission.status == MissionStatus.assigned)
            .toList();
      case MissionListType.pickedUpMissions:
        return _allMissions
            .where((mission) => mission.status == MissionStatus.pickedUp)
            .toList();
      case MissionListType.deliveredMissions:
        return _allMissions
            .where((mission) => mission.status == MissionStatus.delivered)
            .toList();
      case MissionListType.cancelledMissions:
        return _allMissions
            .where((mission) => mission.status == MissionStatus.cancelled)
            .toList();
    }
  }

  void addMission(MissionListType type, Mission mission) {
    _allMissions.add(mission);
    notifyListeners();
  }

  void removeMission(MissionListType type, Mission mission) {
    _allMissions.remove(mission);
    notifyListeners();
  }

  /// Pre-fetches route info for all missions so it's instantly available.
  Future<void> prefetchRouteInfo({String profile = 'car'}) async {
    for (final mission in _allMissions) {
      mission.getRouteInfo(profile: profile);
    }
  }

  void takeMission(Mission mission) {
    // TODO: Update the mission status in the database
    if (isAvailable(mission)) {
      mission.driverUid = authService.currentUser?.uid;
      mission.status = MissionStatus.assigned;
      notifyListeners();
    }
  }

  void abandonMission(Mission mission) {
    // TODO: Update the mission status in the database
    mission.driverUid = null;
    mission.status = MissionStatus.available;
    notifyListeners();
  }

  void updateStatus(Mission mission, MissionStatus newStatus) {
    // TODO: Update the mission status in the database
    mission.status = newStatus;
    notifyListeners();
  }

  void cancelMission(Mission mission, String cancellationReason) {
    // TODO: Update the mission status in the database + the cancellation reason
    mission.cancellationReason = cancellationReason;
    abandonMission(mission);
  }

  bool isAvailable(Mission mission) {
    // TODO: Check if the mission is still available in the database
    return mission.status == MissionStatus.available;
  }
}

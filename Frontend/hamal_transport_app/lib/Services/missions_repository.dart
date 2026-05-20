import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'backend_service.dart';
import 'authentication_service.dart';

class MissionsRepository extends ChangeNotifier {
  static MissionsRepository? _instance;

  final List<Mission> _allMissions = [];

  final AuthenticationService _authService;
  final MissionService? _missionService;

  MissionsRepository._internal({
    required AuthenticationService authService,
    required MissionService? missionService,
  }) : _authService = authService,
       _missionService = missionService;

  factory MissionsRepository({
    List<Mission>? missions,
    AuthenticationService? authService,
    MissionService? missionService,
  }) {
    _instance ??= MissionsRepository._internal(
      authService: authService ?? AuthenticationService(),
      missionService: missionService,
    );
    if (missions != null) {
      _instance!.setMissions(missions);
    } else if (missionService != null) {
      _instance!.loadMissions();
    }
    return _instance!;
  }

  /// Reset the singleton instance (primarily for tests)
  static void reset() {
    _instance = null;
  }

  void setMissions(List<Mission> missions) {
    _allMissions.clear();
    _allMissions.addAll(missions);
    prefetchRouteInfo();
    notifyListeners();
  }

  Future<void> loadMissions() async {
    if (_missionService == null) {
      throw Exception(
        'MissionService not initialized. Please provide one and make sure to run the backend.',
      );
    }
    final missions = await _missionService.getMissions(null, null);
    setMissions(missions);
  }

  void clear() {
    _allMissions.clear();
    notifyListeners();
  }

  List<Mission> getMissions(MissionListType type) {
    switch (type) {
      case MissionListType.myMissions:
        return _allMissions.where((mission) {
          return mission.driverUid == _authService.currentUser?.uid &&
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

  /// Get missions assigned to a specific driver by their UID
  /// TODO: Replace with API endpoint call to query backend for driver-specific missions
  List<Mission> getMissionsByDriver(String driverUid) {
    final allMissions = getMissions(MissionListType.allMissions);
    return allMissions
        .where((mission) => mission.driverUid == driverUid)
        .toList();
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
      mission.driverUid = _authService.currentUser?.uid;
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

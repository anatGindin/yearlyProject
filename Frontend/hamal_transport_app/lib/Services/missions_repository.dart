import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';

class MissionsRepository extends ChangeNotifier {
  static MissionsRepository? _instance;

  final List<Mission> _myMissionsList;
  final List<Mission> _availableMissionsList;
  final AuthenticationService authService;

  MissionsRepository._internal({
    required List<Mission> myMissionsList,
    required List<Mission> availableMissionsList,
    required this.authService,
  }) : _myMissionsList = myMissionsList,
       _availableMissionsList = availableMissionsList;

  factory MissionsRepository({
    List<Mission>? myMissionsList,
    List<Mission>? availableMissionsList,
    AuthenticationService? authService,
  }) {
    // If called with actual data, force update the singleton
    if ((myMissionsList != null && myMissionsList.isNotEmpty) ||
        (availableMissionsList != null && availableMissionsList.isNotEmpty)) {
      _instance = MissionsRepository._internal(
        myMissionsList: myMissionsList ?? [],
        availableMissionsList: availableMissionsList ?? [],
        authService: authService ?? AuthenticationService(),
      );
    } else {
      // Otherwise create if doesn't exist
      _instance ??= MissionsRepository._internal(
        myMissionsList: [],
        availableMissionsList: [],
        authService: authService ?? AuthenticationService(),
      );
    }
    return _instance!;
  }

  List<Mission> getMissions(MissionListType type) {
    switch (type) {
      case MissionListType.myMissions:
        return _myMissionsList;
      case MissionListType.availableMissions:
        return _availableMissionsList;
      case MissionListType.allMissions:
        return [..._myMissionsList, ..._availableMissionsList];
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
    getMissions(type).add(mission);
    notifyListeners();
  }

  void removeMission(MissionListType type, Mission mission) {
    getMissions(type).remove(mission);
    notifyListeners();
  }

  /// Pre-fetches route info for all missions so it's instantly available.
  Future<void> prefetchRouteInfo({String profile = 'car'}) async {
    final allMissions = [..._myMissionsList, ..._availableMissionsList];
    for (final mission in allMissions) {
      mission.getRouteInfo(profile: profile);
    }
  }

  void moveMission(Mission mission, MissionListType from, MissionListType to) {
    getMissions(from).remove(mission);
    getMissions(to).add(mission);
    notifyListeners();
  }

  void takeMission(Mission mission) {
    mission.driverUid = authService.currentUser?.uid;
    mission.status = MissionStatus.chosen;
    moveMission(
      mission,
      MissionListType.availableMissions,
      MissionListType.myMissions,
    );
  }

  void abandonMission(Mission mission) {
    mission.driverUid = null;
    mission.status = MissionStatus.available;
    moveMission(
      mission,
      MissionListType.myMissions,
      MissionListType.availableMissions,
    );
  }

  void updateStatus(Mission mission, MissionStatus newStatus) {
    if (newStatus == MissionStatus.delivered) {
      // TODO: Update remote database + store in dedicated container if needed
      removeMission(MissionListType.myMissions, mission);
    }
    mission.status = newStatus;
    notifyListeners();
  }

  void cancelMission(Mission mission, String cancellationReason) {
    mission.cancellationReason = cancellationReason;
    abandonMission(mission);
  }

  bool isAvailable(Mission mission) {
    return _availableMissionsList.contains(mission) &&
        mission.status == MissionStatus.available;
  }
}

import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'backend_service.dart';
import 'authentication_service.dart';

class MissionsRepository extends ChangeNotifier {
  static MissionsRepository? _instance;

  final Set<MissionStatus> _statusesFetched = {};
  final List<Mission> _allMissions = [];

  final AuthenticationService _authService;
  final BackendService _backendService;

  MissionsRepository._internal({
    required AuthenticationService authService,
    required BackendService backendService,
  }) : _authService = authService,
       // TODO: refactor needed - option to pass missions. check pr #243 for discussion.
       _backendService = backendService;

  factory MissionsRepository({
    List<Mission>? missions,
    AuthenticationService? authService,
    BackendService? backendService,
  }) {
    bool alreadyExisted = _instance != null;
    _instance ??= MissionsRepository._internal(
      authService: authService ?? AuthenticationService(),
      backendService:
          backendService ?? BackendService(authService: authService),
    );
    if (missions != null) {
      _instance!.setMissions(missions);
    } else if (_instance!._backendService.isEnabled() && !alreadyExisted) {
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
    if (!_backendService.isEnabled()) {
      throw Exception(
        'BackendService not initialized. Please provide one and make sure to run the backend.',
      );
    }
    MissionStatus? status;
    UserRole role = _authService.currentUserProfile!.role;
    if (role != UserRole.driver) {
      status = MissionStatus.available;
    }
    final missions = await _backendService.getMissions(status, null);
    setMissions(missions);
  }

  Future<void> fetchMissions(MissionListType type) async {
    if (!_backendService.isEnabled()) {
      throw Exception(
        'BackendService not initialized. Please provide one and make sure to run the backend.',
      );
    }

    final status = _missionListTypeToStatus(type);
    final missions = await _backendService.getMissions(status, null);
    if (status != null) {
      _statusesFetched.add(status);
    }
    _allMissions.addAll(missions);
    notifyListeners();
  }

  MissionStatus? _missionListTypeToStatus(MissionListType type) {
    switch (type) {
      case MissionListType.availableMissions:
        return MissionStatus.available;
      case MissionListType.assignedMissions:
        return MissionStatus.assigned;
      case MissionListType.pickedUpMissions:
        return MissionStatus.pickedUp;
      case MissionListType.deliveredMissions:
        return MissionStatus.delivered;
      case MissionListType.cancelledMissions:
        return MissionStatus.cancelled;
      case MissionListType.myMissions:
      case MissionListType.allMissions:
        return null; // no status filter
    }
  }

  void clear() {
    _allMissions.clear();
    notifyListeners();
  }

  Future<void> refreshMissions() async {
    await loadMissions();
    UserRole role = _authService.currentUserProfile!.role;
    if (role == UserRole.driver) {
      // loadMissions is enough for driver role
      return;
    }
    for (final status in _statusesFetched) {
      _allMissions.addAll(await _backendService.getMissions(status, null));
    }
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
  Future<List<Mission>> getMissionsByDriver(String driverUid) async {
    return await _backendService.getMissions(null, driverUid);
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

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
    final isNewInstance = _instance == null;
    _instance ??= MissionsRepository._internal(
      authService: authService ?? AuthenticationService(),
      backendService:
          backendService ?? BackendService(authService: authService),
    );
    if (missions != null) {
      _instance!.setMissions(missions);
    } else if (isNewInstance && _instance!._backendService.isEnabled()) {
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

  Future<void>? _initialLoadFuture;
  Future<void>? get initialLoadFuture => _initialLoadFuture;

  Future<void> loadMissions({bool force = false}) {
    if (force || _initialLoadFuture == null) {
      _initialLoadFuture = _loadMissionsInternal();
    }
    return _initialLoadFuture!;
  }

  Future<void> _loadMissionsInternal() async {
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
    _allMissions.clear();
    await loadMissions(force: true);
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

  Future<void> takeMission(Mission mission) async {
    if (isAvailable(mission)) {
      try {
        final updatedMission = await _backendService.claimMission(mission.id);
        final index = _allMissions.indexWhere((m) => m.id == mission.id);
        if (index != -1) {
          _allMissions[index] = updatedMission;
        }
        notifyListeners();
      } catch (e) {
        debugPrint('Failed to claim mission: $e');
        rethrow;
      }
    }
  }

  Future<void> abandonMission(Mission mission) async {
    try {
      final updatedMission = await _backendService.abandonMission(mission.id);
      final index = _allMissions.indexWhere((m) => m.id == mission.id);
      if (index != -1) {
        _allMissions[index] = updatedMission;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to abandon mission: $e');
      rethrow;
    }
  }

  Future<void> updateStatus(Mission mission, MissionStatus newStatus) async {
    try {
      final updatedMission = await _backendService.updateMissionStatus(
        mission.id,
        newStatus,
      );
      final index = _allMissions.indexWhere((m) => m.id == mission.id);
      if (index != -1) {
        _allMissions[index] = updatedMission;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to update status: $e');
      rethrow;
    }
  }

  Future<void> cancelMission(Mission mission, String cancellationReason) async {
    try {
      final updatedMission = await _backendService.cancelMission(
        mission.id,
        cancellationReason,
      );
      final index = _allMissions.indexWhere((m) => m.id == mission.id);
      if (index != -1) {
        _allMissions[index] = updatedMission;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to cancel mission: $e');
      rethrow;
    }
  }

  Future<void> archiveMission(Mission mission) async {
    try {
      await _backendService.archiveMission(mission.id);
      _allMissions.removeWhere((m) => m.id == mission.id);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to archive mission: $e');
      rethrow;
    }
  }

  bool isAvailable(Mission mission) {
    return mission.status == MissionStatus.available;
  }
}

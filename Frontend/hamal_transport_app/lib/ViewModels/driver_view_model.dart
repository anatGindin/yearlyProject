import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';

class DriverViewModel extends ChangeNotifier {
  final AuthenticationService _authService;
  final MissionsRepository _missionsRepository;
  final String driverUid;

  UserProfile? _driverProfile;
  bool _isLoading = true;
  String? _errorMessage;

  DriverViewModel({
    required this.driverUid,
    required AuthenticationService authService,
    required MissionsRepository missionsRepository,
  }) : _authService = authService,
       _missionsRepository = missionsRepository {
    _loadDriverProfile();
  }

  // Getters
  UserProfile? get driverProfile => _driverProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get driverName => _driverProfile?.name ?? 'Driver ($driverUid)';
  String get driverEmail => _driverProfile?.email ?? 'N/A';
  String get driverPhone => _driverProfile?.phone ?? 'N/A';
  String? get carType => _driverProfile?.driverProfile?.carType.name;

  // Get missions assigned to this driver
  List<Mission> get driverMissions {
    final allMissions = _missionsRepository.getMissions(
      MissionListType.allMissions,
    );
    return allMissions
        .where((mission) => mission.driverUid == driverUid)
        .toList();
  }

  // Get missions by status
  List<Mission> getMissionsByStatus(MissionStatus status) {
    return driverMissions.where((mission) => mission.status == status).toList();
  }

  Future<void> _loadDriverProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _driverProfile = await _authService.getUserProfileByUid(driverUid);
    } catch (e) {
      _driverProfile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadDriverProfile();
  }
}

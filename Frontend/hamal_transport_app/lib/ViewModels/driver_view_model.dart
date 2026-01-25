import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';

class DriverViewModel extends ChangeNotifier {
  final String driverUid;

  UserProfile? _driverProfile;
  bool _isLoading = true;
  String? _errorMessage;

  DriverViewModel({required this.driverUid, UserProfile? initialProfile}) {
    if (initialProfile != null) {
      _driverProfile = initialProfile;
      _isLoading = false;
    } else {
      _loadDriverProfile();
    }
  }

  // Getters
  UserProfile? get driverProfile => _driverProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get driverName => _driverProfile?.name ?? 'Driver ($driverUid)';
  String get driverEmail {
    final email = _driverProfile?.email ?? '';
    return email.isEmpty ? 'N/A' : email;
  }

  String get driverPhone {
    final phone = _driverProfile?.phone ?? '';
    return phone.isEmpty ? 'N/A' : phone;
  }

  CarType? get carType => _driverProfile?.driverProfile?.carType;

  // Get missions assigned to this driver
  // Always call MissionsRepository() to get the latest singleton instance
  List<Mission> get driverMissions {
    return MissionsRepository().getMissionsByDriver(driverUid);
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
      _driverProfile = await AuthenticationService().getUserProfileByUid(
        driverUid,
      );
    } catch (e) {
      _driverProfile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

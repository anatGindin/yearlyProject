import 'package:hamal_transport_app/Models/contact.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/backend_service.dart';

class FakeBackendService implements BackendService {
  @override
  bool isEnabled() => true;

  List<Mission> missions = [];

  Mission _createDefaultMission(String id) {
    return Mission(
      id: id,
      source: Location(name: 'A', latitude: 0, longitude: 0),
      destination: Location(name: 'B', latitude: 0, longitude: 0),
      description: 'dummy',
      sourceContact: Contact(fullName: 'S', phoneNumber: '000'),
      destinationContact: Contact(fullName: 'D', phoneNumber: '111'),
      time: DateTime.now(),
      comments: [],
      carType: CarType.private,
    );
  }

  @override
  Future<List<Mission>> getMissions(MissionStatus? status, String? driverId) async {
    return missions.where((m) {
      if (status != null && m.status != status) return false;
      if (driverId != null && m.driverUid != driverId) return false;
      return true;
    }).toList();
  }

  @override
  Future<Mission> postMission(Mission mission) async {
    missions.add(mission);
    return mission;
  }

  @override
  Future<Mission> updateMissionStatus(String missionId, MissionStatus newStatus) async {
    final idx = missions.indexWhere((m) => m.id == missionId);
    if (idx != -1) {
      missions[idx].status = newStatus;
      return missions[idx];
    }
    return _createDefaultMission(missionId)..status = newStatus;
  }

  @override
  Future<Mission> claimMission(String missionId) async {
    final idx = missions.indexWhere((m) => m.id == missionId);
    if (idx != -1) {
      missions[idx].status = MissionStatus.assigned;
      return missions[idx];
    }
    return _createDefaultMission(missionId)..status = MissionStatus.assigned;
  }

  @override
  Future<Mission> assignMission(String missionId, String driverUid) async {
    final idx = missions.indexWhere((m) => m.id == missionId);
    if (idx != -1) {
      missions[idx].status = MissionStatus.assigned;
      missions[idx].driverUid = driverUid;
      return missions[idx];
    }
    return _createDefaultMission(missionId)
      ..status = MissionStatus.assigned
      ..driverUid = driverUid;
  }

  @override
  Future<Mission> cancelMission(String missionId, String reason) async {
    final idx = missions.indexWhere((m) => m.id == missionId);
    if (idx != -1) {
      missions[idx].status = MissionStatus.available;
      missions[idx].cancellationReason = reason;
      return missions[idx];
    }
    return _createDefaultMission(missionId)
      ..status = MissionStatus.available
      ..cancellationReason = reason;
  }

  @override
  Future<Mission> abandonMission(String missionId) async {
    final idx = missions.indexWhere((m) => m.id == missionId);
    if (idx != -1) {
      missions[idx].status = MissionStatus.available;
      missions[idx].driverUid = null;
      return missions[idx];
    }
    return _createDefaultMission(missionId)
      ..status = MissionStatus.available
      ..driverUid = null;
  }

  @override
  Future<void> archiveMission(String missionId) async {
    missions.removeWhere((m) => m.id == missionId);
  }

  @override
  Future<void> deleteMission(String missionId) async {
    missions.removeWhere((m) => m.id == missionId);
  }
}

import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import '../Models/mission.dart';
import '../Models/contact.dart';
import '../Models/user_profile.dart';
import '../Utils/launcher_utils.dart';

class MissionViewModel extends ChangeNotifier {
  Mission mission;
  final MissionsRepository _repository;
  late final UserRole userRole;

  MissionViewModel(this.mission, this._repository) {
    userRole = _repository.authService.currentUserProfile!.role;
  }

  MissionStatus status() {
    return mission.status;
  }

  bool get isDriver => userRole == UserRole.driver;

  String location() {
    return '${mission.source.name}\r\n${mission.destination.name}';
  }

  String description() {
    return mission.description;
  }

  Contact sourceContact() {
    return mission.sourceContact;
  }

  Contact destinationContact() {
    return mission.destinationContact;
  }

  DateTime time() {
    return mission.time;
  }

  List<String> comments() {
    return mission.comments;
  }

  CarType carType() {
    return mission.carType;
  }

  /// Update the status of the mission
  void updateStatus(MissionStatus newStatus) {
    if (mission.status == MissionStatus.available &&
        newStatus == MissionStatus.assigned) {
      _repository.takeMission(mission);
    } else {
      _repository.updateStatus(mission, newStatus);
    }
    notifyListeners();
  }

  /// Launch Waze (or fallback to Google Maps).
  /// Returns true if navigation launched, false otherwise.
  Future<bool> launchNavigation() async {
    String address = mission.source.name;

    if (mission.status == MissionStatus.pickedUp) {
      address = mission.destination.name;
    }

    return LauncherUtils.launchNavigation(address);
  }

  void cancelMission(String cancellationReason) {
    // for now we just save the reason, in the future we will send it to the server
    // so the server can notify the logistics supervisor
    _repository.cancelMission(mission, cancellationReason);
  }

  void addComment(String comment) {
    mission.comments.add(comment);
    notifyListeners();
  }

  void deleteComment(int index) {
    if (index < 0 || index >= mission.comments.length) return;
    mission.comments.removeAt(index);
    notifyListeners();
  }

  void editComment(int index, String newComment) {
    if (index < 0 || index >= mission.comments.length) return;
    mission.comments[index] = newComment;
    notifyListeners();
  }
}

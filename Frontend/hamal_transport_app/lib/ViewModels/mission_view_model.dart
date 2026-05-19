import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Services/mission_comments_storage_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import '../Models/mission.dart';
import '../Models/contact.dart';
import '../Models/user_profile.dart';
import '../Services/authentication_service.dart';
import '../Utils/launcher_utils.dart';

class MissionViewModel extends ChangeNotifier {
  Mission mission;
  final MissionsRepository _repository;
  UserRole? userRole;
  bool isLoading = true;

  MissionViewModel(this.mission, this._repository) {
    initUserRole();
    _loadCommentsFromLocalMemory();
  }

  void _loadCommentsFromLocalMemory() async {
    await MissionCommentsStorage.loadCommentsIntoMission(mission);
    notifyListeners();
  }

  void initUserRole() async {
    final authService = AuthenticationService();

    // Try to load from cache first to avoid UI flickering
    if (authService.currentUserProfile != null) {
      userRole = authService.currentUserProfile!.role;
      isLoading = false;
      notifyListeners();
      return;
    }

    if (authService.currentUser != null) {
      final profile = await authService.getUserProfile(
        authService.currentUser!,
      );
      userRole = profile.role;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<UserProfile?>? _driverProfileFuture;

  Future<UserProfile?> get driverProfileFuture {
    if (_driverProfileFuture == null && mission.driverUid != null) {
      _driverProfileFuture = AuthenticationService().getUserProfileByUid(
        mission.driverUid!,
      );
    }
    return _driverProfileFuture ?? Future.value(null);
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
      if (newStatus == MissionStatus.delivered ||
          newStatus == MissionStatus.cancelled) {
        MissionCommentsStorage.clearComments(mission.id);
      }
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
    MissionCommentsStorage.clearComments(mission.id);
  }

  void addComment(String comment) {
    mission.comments.add(comment);
    MissionCommentsStorage.saveCommentsFromMission(mission);
    notifyListeners();
  }

  void deleteComment(int index) {
    if (index < 0 || index >= mission.comments.length) return;
    mission.comments.removeAt(index);
    MissionCommentsStorage.saveCommentsFromMission(mission);
    notifyListeners();
  }

  void editComment(int index, String newComment) {
    if (index < 0 || index >= mission.comments.length) return;
    mission.comments[index] = newComment;
    MissionCommentsStorage.saveCommentsFromMission(mission);
    notifyListeners();
  }
}

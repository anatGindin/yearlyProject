import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import '../Models/mission.dart';

class MissionViewModel extends ChangeNotifier {
  final MissionsListsModel model;

  MissionViewModel(this.model);

  String status(Mission mission) {
    return mission.status;
  }

  String location(Mission mission) {
    return mission.location;
  }

  String description(Mission mission) {
    return mission.description;
  }

  String contact(Mission mission) {
    return mission.contact;
  }

  DateTime time(Mission mission) {
    return mission.time;
  }

  /// Update the status of the mission
  void updateStatus(Mission mission, String newStatus) {
    // mission is passed by reference so it is updeted in the list
    mission.status = newStatus;
    notifyListeners();
  }

  // Check if mission is available
  bool isAvailable(Mission mission) {
    return model.availableMissionsList.contains(mission) &&
        mission.status == 'available';
  }
}

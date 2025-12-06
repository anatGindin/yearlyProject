import 'package:flutter/material.dart';
import '../Models/mission.dart';

class MissionViewModel extends ChangeNotifier {
  Mission mission;
  MissionViewModel(this.mission);

  String status() {
    return mission.status;
  }

  String location() {
    return mission.location;
  }

  String description() {
    return mission.description;
  }

  String contact() {
    return mission.contact;
  }

  DateTime time() {
    return mission.time;
  }

  /// Update the status of the mission
  void updateStatus(String newStatus) {
    // mission is passed by reference so it is updeted in the list
    mission.status = newStatus;
    notifyListeners();
  }
}

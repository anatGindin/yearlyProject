import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/mission.dart';
import '../features/Contact_card/model/contact.dart';

class MissionViewModel extends ChangeNotifier {
  Mission mission;
  MissionViewModel(this.mission);

  MissionStatus status() {
    return mission.status;
  }

  String location() {
    return mission.location;
  }

  String description() {
    return mission.description;
  }

  Contact contact() {
    return mission.contact;
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
    // mission is passed by reference so it is updeted in the list
    mission.status = newStatus;
    notifyListeners();
  }

  /// Launch Waze (or fallback to Google Maps).
  /// Returns true if navigation launched, false otherwise.
  Future<bool> launchNavigation() async {
    final address = mission.location;

    // Try Waze first
    try {
      final wazeUri = Uri.parse('waze://?q=${Uri.encodeComponent(address)}');
      await launchUrl(wazeUri, mode: LaunchMode.externalApplication);
      return true;
    } catch (e) {
      // Ignore and fallback to Google Maps
    }

    // Fallback to Google Maps
    try {
      final googleUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
      );
      await launchUrl(googleUri, mode: LaunchMode.externalApplication);
      return true;
    } catch (e) {
      return false; // View will show the error message
    }
  }

  void cancelMission(String cancellationReason) {
    // for now we just save the reason, in the future we will send it to the server
    // so the server can notify the logistics supervisor
    mission.cancellationReason = cancellationReason;
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
}

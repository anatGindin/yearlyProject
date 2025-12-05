import 'package:flutter/foundation.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';

class AvailableMissionsViewModel extends ChangeNotifier {
  final MissionsListsModel model;

  AvailableMissionsViewModel(this.model);

  List<Mission> get availableMissions => model.availableMissionsList;

  void add(Mission mission) {
    model.availableMissionsList.add(mission);
    notifyListeners();
  }

  void remove(Mission mission) {
    model.availableMissionsList.remove(mission);
    notifyListeners();
  }
}
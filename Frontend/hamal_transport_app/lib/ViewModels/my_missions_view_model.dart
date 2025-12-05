import 'package:flutter/foundation.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';

class MyMissionsViewModel extends ChangeNotifier {
  final MissionsListsModel model;

  MyMissionsViewModel(this.model);

  List<Mission> get myMissions => model.myMissionsList;

  void add(Mission mission) {
    model.myMissionsList.add(mission);
    notifyListeners();
  }

  void remove(Mission mission) {
    model.myMissionsList.remove(mission);
    notifyListeners();
  }

  
}
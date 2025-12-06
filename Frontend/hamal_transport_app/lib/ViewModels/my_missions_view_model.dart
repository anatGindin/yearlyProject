import 'package:flutter/foundation.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';

class MyMissionsViewModel extends ChangeNotifier {
  final MissionsListsModel _model;

  MyMissionsViewModel(this._model);

  List<Mission> get myMissions => _model.myMissionsList;

  void add(Mission mission) {
    _model.myMissionsList.add(mission);
    notifyListeners();
  }

  void remove(Mission mission) {
    _model.myMissionsList.remove(mission);
    notifyListeners();
  }
}

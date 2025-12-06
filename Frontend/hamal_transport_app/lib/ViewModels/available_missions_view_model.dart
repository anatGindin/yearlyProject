import 'package:flutter/foundation.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';

class AvailableMissionsViewModel extends ChangeNotifier {
  final MissionsListsModel _model;

  AvailableMissionsViewModel(this._model);

  List<Mission> get availableMissions => _model.availableMissionsList;

  void add(Mission mission) {
    _model.availableMissionsList.add(mission);
    notifyListeners();
  }

  void remove(Mission mission) {
    _model.availableMissionsList.remove(mission);
    notifyListeners();
  }
}

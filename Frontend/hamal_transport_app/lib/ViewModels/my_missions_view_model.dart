import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'base/missions_view_model_base.dart';

class MyMissionsViewModel extends MissionsViewModelBase {
  final MissionsListsModel _model;

  MyMissionsViewModel(this._model);

  @override
  List<Mission> get sourceList => _model.myMissionsList;

  List<Mission> get myMissions => missions;

  void add(Mission mission) {
    _model.myMissionsList.add(mission);
    notifyListeners();
  }

  void remove(Mission mission) {
    _model.myMissionsList.remove(mission);
    notifyListeners();
  }

  void updateStatusChanged() {
    notifyListeners();
  }
}

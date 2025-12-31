import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'base/missions_view_model_base.dart';

class AvailableMissionsViewModel extends MissionsViewModelBase {
  final MissionsListsModel _model;

  AvailableMissionsViewModel(this._model);

  @override
  List<Mission> get sourceList => _model.availableMissionsList;

  List<Mission> get availableMissions => missions;

  void add(Mission mission) {
    _model.availableMissionsList.add(mission);
    notifyListeners();
  }

  void remove(Mission mission) {
    _model.availableMissionsList.remove(mission);
    notifyListeners();
  }
}

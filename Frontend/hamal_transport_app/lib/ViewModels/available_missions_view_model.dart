import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';

class AvailableMissionsViewModel extends ChangeNotifier {
  final MissionsListsModel _model;
  SortBy _sortBy = SortBy.timeNewestFirst;
  FilterBy _filterBy = FilterBy.noFilter;

  AvailableMissionsViewModel(this._model);

  List<Mission> get availableMissions {
    return _model.availableMissionsList
        .where(MissionsListsModel.getFilterFunction(_filterBy))
        .toList()
      ..sort(MissionsListsModel.getSortComperator(_sortBy));
  }

  String getSortBy(BuildContext context) {
    return MissionsListsModel.getSortBy(context, _sortBy);
  }

  String getFilterBy(BuildContext context) {
    return MissionsListsModel.getFilterBy(context, _filterBy);
  }

  void add(Mission mission) {
    _model.availableMissionsList.add(mission);
    notifyListeners();
  }

  void remove(Mission mission) {
    _model.availableMissionsList.remove(mission);
    notifyListeners();
  }

  void sortBy(SortBy sortByOption) {
    _sortBy = sortByOption;
    notifyListeners();
  }

  void filterBy(FilterBy filterByOption) {
    _filterBy = filterByOption;
    notifyListeners();
  }
}

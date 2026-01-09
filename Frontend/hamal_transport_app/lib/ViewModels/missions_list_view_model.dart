import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Services/location_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';

class MissionsListViewModel extends ChangeNotifier {
  final MissionsRepository _repository;
  final MissionListType _type;
  final List<SortBy> allowedSortOptions;
  final List<FilterBy> allowedFilterOptions;

  SortBy _sortBy = SortBy.timeNewestFirst;
  FilterBy _filterBy = FilterBy.noFilter;
  Location? _userLocation;

  MissionsListViewModel({
    required MissionsRepository repository,
    required MissionListType type,
    this.allowedSortOptions = SortBy.values,
    this.allowedFilterOptions = FilterBy.values,
  }) : _repository = repository,
       _type = type {
    _repository.addListener(notifyListeners);

    // Ensure default sort/filter are allowed
    if (!allowedSortOptions.contains(_sortBy) &&
        allowedSortOptions.isNotEmpty) {
      _sortBy = allowedSortOptions.first;
    }
    if (!allowedFilterOptions.contains(_filterBy) &&
        allowedFilterOptions.isNotEmpty) {
      _filterBy = allowedFilterOptions.first;
    }
  }

  @override
  void dispose() {
    _repository.removeListener(notifyListeners);
    super.dispose();
  }

  List<Mission> get sourceList => _repository.getMissions(_type);

  List<Mission> get missions {
    return sourceList
        .where(MissionsListsModel.getFilterFunction(_filterBy))
        .toList()
      ..sort(
        MissionsListsModel.getSortComperator(
          _sortBy,
          userLocation: _userLocation,
        ),
      );
  }

  String getSortBy(BuildContext context) {
    return _sortBy.getLabel(context);
  }

  String getFilterBy(BuildContext context) {
    return _filterBy.getLabel(context);
  }

  void sortBy(SortBy sortByOption) {
    _sortBy = sortByOption;
    notifyListeners();
  }

  Future<bool> sortByGps(SortBy sortByOption) async {
    final resolvedLocation = await _resolveUserLocation();
    if (resolvedLocation == null) {
      return false;
    }

    _userLocation = resolvedLocation;
    _sortBy = sortByOption;
    notifyListeners();
    return true;
  }

  Future<Location?> _resolveUserLocation() async {
    final locationService = LocationService();
    final hasPermissions = await locationService.checkPermissions();
    if (!hasPermissions) return null;

    Position? position = locationService.currentPosition;
    position ??= await locationService.getCurrentLocationOnce();
    if (position == null) return null;

    return Location(
      name: 'GPS',
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  void filterBy(FilterBy filterByOption) {
    _filterBy = filterByOption;
    notifyListeners();
  }

  void add(Mission mission) {
    _repository.addMission(_type, mission);
  }

  void remove(Mission mission) {
    _repository.removeMission(_type, mission);
  }

  void updateStatusChanged() {
    notifyListeners();
  }
}

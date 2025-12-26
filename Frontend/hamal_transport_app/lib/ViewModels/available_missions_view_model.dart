import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/Services/location_service.dart';

class AvailableMissionsViewModel extends ChangeNotifier {
  final MissionsListsModel _model;
  SortBy _sortBy = SortBy.timeNewestFirst;
  FilterBy _filterBy = FilterBy.noFilter;
  Location? _userLocation;

  AvailableMissionsViewModel(this._model);

  List<Mission> get availableMissions {
    return _model.availableMissionsList
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

    locationService.startLocationUpdates();

    Position? position = locationService.currentPosition;
    if (position == null) {
      try {
        position = await locationService.positionStream.first.timeout(
          const Duration(seconds: 10),
        );
      } catch (_) {
        // Ignore timeout/stream errors.
      }
    }

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
}

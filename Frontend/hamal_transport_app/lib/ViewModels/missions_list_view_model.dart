import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/Services/location_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/Models/israel_districts.dart';

class MissionsListViewModel extends ChangeNotifier {
  final MissionsRepository _repository;
  final MissionListType _type;
  final List<SortBy> allowedSortOptions;
  final List<FilterBy> allowedFilterOptions;
  late UserRole _role;

  SortBy _sortBy = SortBy.timeNewestFirst;
  FilterBy _filterBy = FilterBy.noFilter;
  final List<IsraelDistrict> _selectedDistricts = [];
  Location? _userLocation;
  bool _isFetched = false;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  MissionsListViewModel({
    UserRole? role,
    MissionsRepository? repository,
    required MissionListType type,
    this.allowedSortOptions = SortBy.values,
    this.allowedFilterOptions = FilterBy.values,
  }) : _repository = repository ?? MissionsRepository(),
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
    if (role != null) {
      _role = role;
    } else {
      _role = AuthenticationService().currentUserProfile!.role;
    }
    if ((_role != UserRole.driver &&
            type == MissionListType.availableMissions) ||
        type == MissionListType.myMissions) {
      _isFetched = true;
    }
  }

  MissionListType get type => _type;

  @override
  void dispose() {
    _repository.removeListener(notifyListeners);
    super.dispose();
  }

  List<Mission> get sourceList => _repository.getMissions(_type);

  List<Mission> get missions {
    var filteredMissions = sourceList.where(
      MissionsListsModel.getFilterFunction(_filterBy),
    );

    if (_selectedDistricts.isNotEmpty) {
      filteredMissions = filteredMissions.where((mission) {
        final district = DistrictPolygons.getDistrictForLocation(
          mission.destination,
        );
        return district != null && _selectedDistricts.contains(district);
      });
    }

    return filteredMissions.toList()..sort(
      MissionsListsModel.getSortComperator(
        _sortBy,
        userLocation: _userLocation,
      ),
    );
  }

  Future<void> refreshMissions() async {
    _isLoading = true;
    notifyListeners();
    await _repository.refreshMissions();
    _isLoading = false;
    notifyListeners();
  }

  List<IsraelDistrict> get selectedDistricts => _selectedDistricts;

  void toggleDistrict(IsraelDistrict district, bool isSelected) {
    if (isSelected) {
      if (!_selectedDistricts.contains(district)) {
        _selectedDistricts.add(district);
      }
    } else {
      _selectedDistricts.remove(district);
    }
    notifyListeners();
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

  Future<void> archiveAllMissions() async {
    _isLoading = true;
    notifyListeners();
    try {
      final currentMissions = List<Mission>.from(missions);
      for (final mission in currentMissions) {
        await _repository.archiveMission(mission);
      }
    } catch (e) {
      debugPrint('Failed to archive all missions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMissions() async {
    if (_repository.initialLoadFuture != null) {
      _isLoading = true;
      notifyListeners();
      try {
        await _repository.initialLoadFuture;
      } catch (e) {
        debugPrint('Error during repository initial load: $e');
      }
    }

    if (_isFetched) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    await _repository.fetchMissions(_type);
    _isFetched = true;
    _isLoading = false;
    notifyListeners();
  }
}

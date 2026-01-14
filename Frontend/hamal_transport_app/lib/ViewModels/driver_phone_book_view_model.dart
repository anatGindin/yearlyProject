import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import '../Models/user_profile.dart';

class DriverPhoneBookViewModel extends ChangeNotifier {
  final List<UserProfile> _allUsers = List<UserProfile>.empty(growable: true);
  CarType? _carTypeFilter;
  List<CarType?> allowedFilterOptions = [null, ...CarType.values];

  String _query = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DriverPhoneBookViewModel() {
    _getUsers();
  }

  String get query => _query;

  List<UserProfile> get drivers {
    final filtered = _allUsers
        .where((u) => u.role == UserRole.driver)
        .where(
          (u) => _carTypeFilter != null
              ? u.driverProfile!.carType == _carTypeFilter
              : true,
        )
        .where(
          (u) =>
              u.name.toLowerCase().contains(_query.toLowerCase()) ||
              u.phone.contains(_query),
        )
        .toList();
    // always sort alphabetically
    filtered.sort((a, b) => a.name.compareTo(b.name));

    return filtered;
  }

  CarType? get filter => _carTypeFilter;

  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> _getUsers() async {
    //TODO: get users from the backhand
    _isLoading = true;
    final authService = AuthenticationService();
    UserProfile? driverProfile;
    try {
      driverProfile = await authService.getUserProfileByUid(
        "I9ivZ6H8pYWoDkeb2wybbKXgxWE2",
      );
    } catch (e) {
      driverProfile = null;
    } finally {
      if (driverProfile != null) {
        _allUsers.add(driverProfile);
      }
    }
    try {
      driverProfile = await authService.getUserProfileByUid(
        "QQPq3Ww6ZcQsLwiLxESb5lMj7it1",
      );
    } catch (e) {
      driverProfile = null;
    } finally {
      if (driverProfile != null) {
        _allUsers.add(driverProfile);
      }
    }
    try {
      driverProfile = await authService.getUserProfileByUid(
        "MFdpfMkvRxVTKJFMwkvaibFTocy1",
      );
    } catch (e) {
      driverProfile = null;
    } finally {
      if (driverProfile != null) {
        _allUsers.add(driverProfile);
      }
    }
    try {
      driverProfile = await authService.getUserProfileByUid(
        "nTaztLupVDeL3RJGd5EvVWzc4Fr2",
      );
    } catch (e) {
      driverProfile = null;
    } finally {
      if (driverProfile != null) {
        _allUsers.add(driverProfile);
      }
    }
    try {
      driverProfile = await authService.getUserProfileByUid(
        "tTRvyduHWwM5fc5uMPXenxEaaGj2",
      );
    } catch (e) {
      driverProfile = null;
    } finally {
      if (driverProfile != null) {
        _allUsers.add(driverProfile);
      }
      notifyListeners();
    }
    _isLoading = false;
  }

  String getFilterBy(AppLocalizations l10n, CarType? option) {
    switch (option) {
      case null:
        return l10n.allCarTypes;
      case CarType.private:
        return l10n.privateOnly;
      case CarType.trailer:
        return l10n.trailerOnly;
      case CarType.pickupTruck:
        return l10n.pickupOnly;
      case CarType.truck:
        return l10n.truckOnly;
    }
  }

  void filterBy(CarType? option) {
    _carTypeFilter = option;
    notifyListeners();
  }
}

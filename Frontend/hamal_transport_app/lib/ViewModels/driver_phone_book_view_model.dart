import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import '../Models/user_profile.dart';

class DriverPhoneBookViewModel extends ChangeNotifier {
  final List<UserProfile> _allUsers = List<UserProfile>.empty(growable: true);
  CarType? _carTypeFilter;
  List<CarType?> allowedFilterOptions = [null, ...CarType.values];

  String _query = '';

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
    //TODO: get users from firebase or mock data
    final authService = AuthenticationService();
    List<UserProfile>? drivers;
    try {
      drivers = await authService.getDrivers();
    } catch (e) {
      drivers = null;
    } finally {
      if (drivers != null) {
        _allUsers.addAll(drivers);
      }
      notifyListeners();
    }
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

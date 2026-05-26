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

  /// Drivers grouped by their first letter, in alphabetical order.
  Map<String, List<UserProfile>> get groupedDrivers {
    final result = <String, List<UserProfile>>{};
    for (final driver in drivers) {
      final letter = driver.name.isNotEmpty
          ? driver.name[0].toUpperCase()
          : '#';
      result.putIfAbsent(letter, () => []).add(driver);
    }

    final sortedByKeys = Map.fromEntries(
      result.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return sortedByKeys;
  }

  CarType? get filter => _carTypeFilter;

  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> _getUsers() async {
    _isLoading = true;
    notifyListeners();
    final authService = AuthenticationService();
    try {
      final drivers = await authService.getAllDrivers();
      _allUsers.clear();
      _allUsers.addAll(drivers);
    } catch (e) {
      debugPrint('Error fetching drivers: $e');
    } finally {
      _isLoading = false;
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

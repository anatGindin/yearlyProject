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
      notifyListeners();
    }
    _allUsers.add(
      UserProfile(
        uid: "uid1",
        email: 'uid1@email.com',
        name: 'user 1',
        phone: '0501234567',
        role: UserRole.driver,
        driverProfile: DriverProfile(carType: CarType.private),
      ),
    );
    _allUsers.add(
      UserProfile(
        uid: "uid2",
        email: 'uid2@email.com',
        name: 'user 2',
        phone: '0501234568',
        role: UserRole.driver,
        driverProfile: DriverProfile(carType: CarType.truck),
      ),
    );
    _allUsers.add(
      UserProfile(
        uid: "uid3",
        email: 'uid3@email.com',
        name: 'user 3',
        phone: '0501234569',
        role: UserRole.driver,
        driverProfile: DriverProfile(carType: CarType.private),
      ),
    );
    _allUsers.add(
      UserProfile(
        uid: "uid4",
        email: 'uid4@email.com',
        name: 'user 4',
        phone: '0501234560',
        role: UserRole.driver,
        driverProfile: DriverProfile(carType: CarType.trailer),
      ),
    );
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

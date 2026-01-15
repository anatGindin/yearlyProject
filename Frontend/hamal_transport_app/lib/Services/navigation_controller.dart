import 'package:flutter/material.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';

class MainNavigationController extends ChangeNotifier {
  NavBarPageType? _requestedPageType;

  NavBarPageType? get requestedPageType => _requestedPageType;

  void navigateTo(NavBarPageType type) {
    _requestedPageType = type;
    notifyListeners();
  }

  void consumeRequest() {
    _requestedPageType = null;
  }
}

enum NavBarPageType {
  missions,
  mapView,
  profile,
  drivers;

  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case NavBarPageType.missions:
        return l10n.missions;
      case NavBarPageType.mapView:
        return l10n.map;
      case NavBarPageType.profile:
        return l10n.profile;
      case NavBarPageType.drivers:
        return l10n.drivers;
    }
  }

  IconData getIcon() {
    switch (this) {
      case NavBarPageType.missions:
        return Icons.list;
      case NavBarPageType.mapView:
        return Icons.map;
      case NavBarPageType.profile:
        return Icons.person;
      case NavBarPageType.drivers:
        return Icons.drive_eta;
    }
  }
}

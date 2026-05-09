import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';

enum IsraelDistrict {
  north,
  haifa,
  center,
  telAviv,
  jerusalem,
  south,
  judeaAndSamaria;

  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case IsraelDistrict.north:
        return l10n.districtNorth;
      case IsraelDistrict.haifa:
        return l10n.districtHaifa;
      case IsraelDistrict.center:
        return l10n.districtCenter;
      case IsraelDistrict.telAviv:
        return l10n.districtTelAviv;
      case IsraelDistrict.jerusalem:
        return l10n.districtJerusalem;
      case IsraelDistrict.south:
        return l10n.districtSouth;
      case IsraelDistrict.judeaAndSamaria:
        return l10n.districtJudeaAndSamaria;
    }
  }
}

class DistrictPolygons {
  // Approximate coordinate polygons for Israel's districts
  static final Map<IsraelDistrict, List<List<double>>> _polygons = {
    IsraelDistrict.north: [
      [34.9, 32.5],
      [35.6, 32.4],
      [35.9, 32.8],
      [35.7, 33.3],
      [35.1, 33.1],
      [34.9, 32.5],
    ],
    IsraelDistrict.haifa: [
      [34.9, 32.3],
      [35.2, 32.3],
      [35.2, 32.8],
      [34.9, 32.8],
      [34.9, 32.3],
    ],
    IsraelDistrict.telAviv: [
      [34.7, 32.0],
      [34.9, 32.0],
      [34.9, 32.2],
      [34.7, 32.2],
      [34.7, 32.0],
    ],
    IsraelDistrict.center: [
      [34.8, 31.8],
      [35.0, 31.8],
      [35.0, 32.4],
      [34.8, 32.4],
      [34.8, 31.8],
    ],
    IsraelDistrict.jerusalem: [
      [34.9, 31.7],
      [35.2, 31.7],
      [35.2, 31.9],
      [34.9, 31.9],
      [34.9, 31.7],
    ],
    IsraelDistrict.judeaAndSamaria: [
      [35.0, 31.3],
      [35.6, 31.5],
      [35.6, 32.5],
      [35.0, 32.5],
      [35.0, 31.3],
    ],
    IsraelDistrict.south: [
      [34.2, 29.5],
      [35.0, 29.5],
      [35.4, 31.4],
      [34.2, 31.4],
      [34.2, 29.5],
    ],
  };

  static IsraelDistrict? getDistrictForLocation(Location location) {
    for (final entry in _polygons.entries) {
      if (_isPointInPolygon(location, entry.value)) {
        return entry.key;
      }
    }
    return null;
  }

  static bool _isPointInPolygon(Location point, List<List<double>> polygon) {
    final double x = point.longitude;
    final double y = point.latitude;
    bool isInside = false;

    int j = polygon.length - 1;
    for (int i = 0; i < polygon.length; i++) {
      final double xi = polygon[i][0];
      final double yi = polygon[i][1];
      final double xj = polygon[j][0];
      final double yj = polygon[j][1];

      final bool intersect =
          ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
      if (intersect) isInside = !isInside;

      j = i;
    }
    return isInside;
  }
}

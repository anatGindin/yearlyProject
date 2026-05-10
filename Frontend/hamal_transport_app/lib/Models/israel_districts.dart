import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';

enum IsraelDistrict {
  north,
  center,
  jerusalem,
  south;

  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case IsraelDistrict.north:
        return l10n.districtNorth;
      case IsraelDistrict.center:
        return l10n.districtCenter;
      case IsraelDistrict.jerusalem:
        return l10n.districtJerusalem;
      case IsraelDistrict.south:
        return l10n.districtSouth;
    }
  }
}

class DistrictPolygons {
  // Simplified to 4 main districts covering the whole country
  static final Map<IsraelDistrict, List<List<double>>> _polygons = {
    IsraelDistrict.jerusalem: [
      [34.9, 31.6],
      [35.6, 31.6],
      [35.6, 31.95],
      [34.9, 31.95],
      [34.9, 31.6],
    ],
    IsraelDistrict.north: [
      [34.8, 32.4],
      [35.9, 32.4],
      [35.9, 33.5],
      [34.8, 33.5],
      [34.8, 32.4],
    ],
    IsraelDistrict.center: [
      [34.4, 31.7],
      [35.6, 31.7],
      [35.6, 32.5],
      [34.4, 32.5],
      [34.4, 31.7],
    ],
    IsraelDistrict.south: [
      [34.1, 29.4],
      [35.6, 29.4],
      [35.6, 31.8],
      [34.1, 31.8],
      [34.1, 29.4],
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

  /// An implementation of the [Even Odd rule](https://en.wikipedia.org/wiki/Even%E2%80%93odd_rule).
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

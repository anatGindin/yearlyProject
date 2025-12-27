import 'dart:math' as math;

class Location implements Comparable<Location> {
  final String name;
  final double latitude;
  final double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'latitude': latitude, 'longitude': longitude};
  }

  /// Calculate distance to another location using Haversine formula
  /// Returns distance in kilometers
  double distanceTo(Location other) {
    const double earthRadius = 6371; // Earth radius in kilometers

    final double dLat = _toRadians(other.latitude - latitude);
    final double dLon = _toRadians(other.longitude - longitude);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(latitude)) *
            math.cos(_toRadians(other.latitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }

  /// Compare locations by name (alphabetically)
  @override
  int compareTo(Location other) {
    return name.compareTo(other.name);
  }

  // Math helper functions
  static double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}

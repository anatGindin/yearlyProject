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
        _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(latitude)) *
            _cos(_toRadians(other.latitude)) *
            _sin(dLon / 2) *
            _sin(dLon / 2);

    final double c = 2 * _asin(_sqrt(a));

    return earthRadius * c;
  }

  /// Compare locations by name (alphabetically)
  @override
  int compareTo(Location other) {
    return name.compareTo(other.name);
  }

  // Math helper functions
  static double _toRadians(double degrees) {
    return degrees * 3.141592653589793 / 180;
  }

  static double _sin(double radians) {
    // Using Taylor series approximation for sine
    double result = radians;
    double term = radians;
    for (int i = 1; i < 10; i++) {
      term *= -radians * radians / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  static double _cos(double radians) {
    // Using Taylor series approximation for cosine
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i < 10; i++) {
      term *= -radians * radians / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  static double _sqrt(double value) {
    if (value < 0) return double.nan;
    if (value == 0) return 0;

    // Newton's method for square root
    double guess = value / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + value / guess) / 2;
    }
    return guess;
  }

  static double _asin(double value) {
    // Using Taylor series approximation for arcsin
    if (value < -1 || value > 1) return double.nan;

    double result = value;
    double term = value;
    for (int i = 1; i < 10; i++) {
      term *=
          value * value * (2 * i - 1) * (2 * i - 1) / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }
}

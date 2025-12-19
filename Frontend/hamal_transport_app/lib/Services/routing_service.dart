import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for calculating routes using OpenStreetMap (OSRM)
class RoutingService {
  // OSRM demo server (free, no API key needed)
  static const String _baseUrl = 'https://router.project-osrm.org';

  /// Calculate route between two points
  ///
  /// Returns a RouteResult with distance (in meters) and duration (in seconds)
  ///
  /// Parameters:
  /// - startLat: Starting point latitude
  /// - startLon: Starting point longitude
  /// - endLat: Destination point latitude
  /// - endLon: Destination point longitude
  /// - profile: Transportation mode ('car', 'bike', 'foot') - default is 'car'
  static Future<RouteResult?> getRoute({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
    String profile = 'car',
  }) async {
    try {
      // Build OSRM API URL
      final url = Uri.parse(
        '$_baseUrl/route/v1/$profile/$startLon,$startLat;$endLon,$endLat?overview=false',
      );

      // Make HTTP request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if route was found
        if (data['code'] == 'Ok' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final route = data['routes'][0];

          return RouteResult(
            distanceInMeters: route['distance'].toDouble(),
            durationInSeconds: route['duration'].toDouble(),
          );
        }
      }

      return null;
    } catch (e) {
      print('Error getting route: $e');
      return null;
    }
  }

  /// Calculate route with human-readable format
  static Future<RouteInfo?> getRouteInfo({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
    String profile = 'car',
  }) async {
    final result = await getRoute(
      startLat: startLat,
      startLon: startLon,
      endLat: endLat,
      endLon: endLon,
      profile: profile,
    );

    if (result == null) return null;

    return RouteInfo(
      distanceKm: result.distanceInMeters / 1000,
      durationMinutes: result.durationInSeconds / 60,
      distanceInMeters: result.distanceInMeters,
      durationInSeconds: result.durationInSeconds,
    );
  }
}

/// Raw route result from API
class RouteResult {
  final double distanceInMeters;
  final double durationInSeconds;

  RouteResult({
    required this.distanceInMeters,
    required this.durationInSeconds,
  });
}

/// Human-readable route information
class RouteInfo {
  final double distanceKm;
  final double durationMinutes;
  final double distanceInMeters;
  final double durationInSeconds;

  RouteInfo({
    required this.distanceKm,
    required this.durationMinutes,
    required this.distanceInMeters,
    required this.durationInSeconds,
  });

  /// Format distance as string (e.g., "5.2 km" or "850 m")
  String get formattedDistance {
    if (distanceKm >= 1) {
      return '${distanceKm.toStringAsFixed(1)} km';
    } else {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    }
  }

  /// Format duration as string (e.g., "1h 30m" or "45m")
  String get formattedDuration {
    final hours = (durationMinutes / 60).floor();
    final minutes = (durationMinutes % 60).round();

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  String toString() {
    return 'Distance: $formattedDistance, Duration: $formattedDuration';
  }
}

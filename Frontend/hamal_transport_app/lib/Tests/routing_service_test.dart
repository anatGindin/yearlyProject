import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Services/routing_service.dart';

void main() {
  group('RoutingService Tests', () {
    test('Calculate route from Tel Aviv to Jerusalem', () async {
      // Tel Aviv coordinates
      const startLat = 32.0853;
      const startLon = 34.7818;

      // Jerusalem coordinates
      const endLat = 31.7683;
      const endLon = 35.2137;

      final routeInfo = await RoutingService.getRouteInfo(
        startLat: startLat,
        startLon: startLon,
        endLat: endLat,
        endLon: endLon,
        profile: 'car',
      );

      // Verify route was calculated
      expect(routeInfo, isNotNull);

      if (routeInfo != null) {
        // Distance should be reasonable (between 50-80 km)
        expect(routeInfo.distanceKm, greaterThan(50));
        expect(routeInfo.distanceKm, lessThan(80));

        // Duration should be reasonable (between 45-90 minutes)
        expect(routeInfo.durationMinutes, greaterThan(45));
        expect(routeInfo.durationMinutes, lessThan(90));

        // Check formatted output
        expect(routeInfo.formattedDistance, isNotEmpty);
        expect(routeInfo.formattedDuration, isNotEmpty);
      }
    });

    test('Format distance correctly', () async {
      const startLat = 32.0853;
      const startLon = 34.7818;
      // Short distance (same city, ~500m away)
      const endLat = 32.0900;
      const endLon = 34.7850;

      final routeInfo = await RoutingService.getRouteInfo(
        startLat: startLat,
        startLon: startLon,
        endLat: endLat,
        endLon: endLon,
        profile: 'car',
      );

      expect(routeInfo, isNotNull);
      if (routeInfo != null) {
        // Short distances should be in meters
        if (routeInfo.distanceKm < 1) {
          expect(routeInfo.formattedDistance, contains('m'));
          expect(routeInfo.formattedDistance, isNot(contains('km')));
        }
      }
    });

    test('Handle different transport profiles', () async {
      const startLat = 32.0853;
      const startLon = 34.7818;
      const endLat = 31.7683;
      const endLon = 35.2137;

      // Car route
      final carRoute = await RoutingService.getRouteInfo(
        startLat: startLat,
        startLon: startLon,
        endLat: endLat,
        endLon: endLon,
        profile: 'car',
      );

      expect(carRoute, isNotNull);
    });
  });
}

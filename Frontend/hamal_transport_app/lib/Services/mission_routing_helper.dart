import 'package:flutter/material.dart';
import '../Models/mission.dart';
import '../Services/routing_service.dart';

/// Extension to add route calculation capabilities to Mission
extension MissionRouting on Mission {
  /// Calculate route from current location to mission destination
  ///
  /// Parameters:
  /// - currentLat: Your current latitude
  /// - currentLon: Your current longitude
  /// - destinationLat: Mission destination latitude
  /// - destinationLon: Mission destination longitude
  Future<RouteInfo?> calculateRouteToMission({
    required double currentLat,
    required double currentLon,
    required double destinationLat,
    required double destinationLon,
  }) async {
    return await RoutingService.getRouteInfo(
      startLat: currentLat,
      startLon: currentLon,
      endLat: destinationLat,
      endLon: destinationLon,
      profile: 'car',
    );
  }
}

/// Widget to display route information for a mission
class MissionRouteInfo extends StatefulWidget {
  final double currentLat;
  final double currentLon;
  final double destinationLat;
  final double destinationLon;

  const MissionRouteInfo({
    super.key,
    required this.currentLat,
    required this.currentLon,
    required this.destinationLat,
    required this.destinationLon,
  });

  @override
  State<MissionRouteInfo> createState() => _MissionRouteInfoState();
}

class _MissionRouteInfoState extends State<MissionRouteInfo> {
  RouteInfo? _routeInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    final routeInfo = await RoutingService.getRouteInfo(
      startLat: widget.currentLat,
      startLon: widget.currentLon,
      endLat: widget.destinationLat,
      endLon: widget.destinationLon,
    );

    if (mounted) {
      setState(() {
        _routeInfo = routeInfo;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Calculating route...'),
        ],
      );
    }

    if (_routeInfo == null) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning, size: 16, color: Colors.orange),
          SizedBox(width: 8),
          Text('Route unavailable'),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.directions_car, size: 16),
        const SizedBox(width: 4),
        Text(_routeInfo!.formattedDistance),
        const SizedBox(width: 12),
        const Icon(Icons.schedule, size: 16),
        const SizedBox(width: 4),
        Text(_routeInfo!.formattedDuration),
      ],
    );
  }
}

/// Simple card widget to show route info
class RouteInfoCard extends StatelessWidget {
  final RouteInfo routeInfo;

  const RouteInfoCard({super.key, required this.routeInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.directions_car, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routeInfo.formattedDistance,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Estimated time: ${routeInfo.formattedDuration}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

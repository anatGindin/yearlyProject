import 'package:flutter/material.dart';
import '../Services/routing_service.dart';

/// Practical example: Add route info to your mission card
class MissionCardWithRouteInfo extends StatelessWidget {
  final String missionId;
  final String location;
  final String description;
  final double destinationLat;
  final double destinationLon;
  final double? currentLat; // Optional current location
  final double? currentLon;

  const MissionCardWithRouteInfo({
    super.key,
    required this.missionId,
    required this.location,
    required this.description,
    required this.destinationLat,
    required this.destinationLon,
    this.currentLat,
    this.currentLon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),

            // Show route info if current location is available
            if (currentLat != null && currentLon != null)
              FutureBuilder<RouteInfo?>(
                future: RoutingService.getRouteInfo(
                  startLat: currentLat!,
                  startLon: currentLon!,
                  endLat: destinationLat,
                  endLon: destinationLon,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Row(
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

                  if (snapshot.hasData && snapshot.data != null) {
                    final route = snapshot.data!;
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.directions_car,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            route.formattedDistance,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.schedule,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            route.formattedDuration,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Example: List of missions with route info
class MissionsListWithRoutes extends StatefulWidget {
  const MissionsListWithRoutes({super.key});

  @override
  State<MissionsListWithRoutes> createState() => _MissionsListWithRoutesState();
}

class _MissionsListWithRoutesState extends State<MissionsListWithRoutes> {
  // Simulated current location (Tel Aviv)
  final double currentLat = 32.0853;
  final double currentLon = 34.7818;

  // Sample missions with coordinates
  final List<Map<String, dynamic>> missions = [
    {
      'id': 'm1',
      'location': 'Jerusalem - Ben Yehuda 12',
      'description': 'Urgent envelope',
      'lat': 31.7683,
      'lon': 35.2137,
    },
    {
      'id': 'm2',
      'location': 'Haifa - HaNassi 3',
      'description': 'Large box, requires cart',
      'lat': 32.7940,
      'lon': 34.9896,
    },
    {
      'id': 'm3',
      'location': 'Be\'er Sheva - Rager Blvd',
      'description': 'Small package',
      'lat': 31.2518,
      'lon': 34.7913,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Missions with Route Info')),
      body: ListView.builder(
        itemCount: missions.length,
        itemBuilder: (context, index) {
          final mission = missions[index];
          return MissionCardWithRouteInfo(
            missionId: mission['id'],
            location: mission['location'],
            description: mission['description'],
            destinationLat: mission['lat'],
            destinationLon: mission['lon'],
            currentLat: currentLat,
            currentLon: currentLon,
          );
        },
      ),
    );
  }
}

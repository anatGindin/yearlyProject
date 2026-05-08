import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Algorithms/best_route.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/Models/contact.dart';
import 'package:hamal_transport_app/Models/user_profile.dart'; // For CarType if needed

void main() {
  List<Mission> generateMissions(int count, Random random) {
    return List.generate(count, (i) {
      return Mission(
        id: 'm$i',
        description: 'Mission $i',
        source: Location(
          name: 'S$i',
          latitude: 32.0 + random.nextDouble() * 2,
          longitude: 34.0 + random.nextDouble() * 2,
        ),
        destination: Location(
          name: 'D$i',
          latitude: 32.0 + random.nextDouble() * 2,
          longitude: 34.0 + random.nextDouble() * 2,
        ),
        sourceContact: Contact(fullName: 'CS$i', phoneNumber: '050-1111111'),
        destinationContact: Contact(
          fullName: 'CD$i',
          phoneNumber: '050-2222222',
        ),
        time: DateTime.now(),
        comments: [],
        carType: CarType.private,
        status: MissionStatus.available,
      );
    });
  }

  group('BestRoute Algorithm Stress Test', () {
    test('missions stress test', () {
      print("\n--- BestRoute Algorithm Stress Test ---");
      print(
        "Count | Opt Time (ms) | Greedy Time (ms) | Opt Dist | Greedy Dist | Benefit (%)",
      );
      print(
        "--------------------------------------------------------------------------------",
      );

      final random = Random();
      final start = Location(name: "Start", latitude: 32.8, longitude: 35.0);

      for (int n = 1; n <= 10; n++) {
        final missions = generateMissions(n, random);

        // Benchmark
        final results = BestRoute.benchmark(missions, start);

        final count = results['count'].toString().padRight(5);
        final optTime = results['optimalTime'].toStringAsFixed(2).padLeft(12);
        final greedyTime = results['greedyTime'].toStringAsFixed(2).padLeft(14);
        final optDist = results['optimalDist'].toStringAsFixed(2).padLeft(10);
        final greedyDist = results['greedyDist'].toStringAsFixed(2).padLeft(11);
        final benefit = results['improvement'].toStringAsFixed(2).padLeft(11);

        print(
          "$count | $optTime | $greedyTime | $optDist | $greedyDist | $benefit",
        );

        if (results['optimalTime'] > 2000) {
          print(">> Optimal search taking too long (>2s). Stopping iteration.");
          break;
        }
      }
    });
  });
}

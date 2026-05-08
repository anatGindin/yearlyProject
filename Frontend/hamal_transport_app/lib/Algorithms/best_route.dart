import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/location.dart';
import '../Constants/official_info.dart';
import 'package:latlong2/latlong.dart';

enum Action { pickUp, deliver }

class RouteStep {
  final Action action;
  final Mission mission;

  RouteStep(this.action, this.mission);

  Location get location =>
      action == Action.pickUp ? mission.source : mission.destination;

  @override
  String toString() => "${action.name} ${mission.description}";
}

class BestRoute {
  static final int _optimalSearchLimit = 6;

  /// Calculates the best route for a list of missions.
  /// Uses an optimal search for small mission sets and a greedy approach for larger ones.
  static List<RouteStep> calculateBestRoute(
    List<Mission> missions, {
    LatLng startingLocation = hamalWarehouse,
  }) {
    // Filter out delivered or cancelled missions
    final activeMissions = missions
        .where(
          (m) =>
              m.status != MissionStatus.delivered &&
              m.status != MissionStatus.cancelled &&
              m.status != MissionStatus.available,
        )
        .toList();

    if (activeMissions.isEmpty) return [];

    Location start = Location(
      name: "Starting Point",
      latitude: startingLocation.latitude,
      longitude: startingLocation.longitude,
    );

    // Identify missions already picked up
    List<Mission> waiting = activeMissions
        .where((m) => m.status != MissionStatus.pickedUp)
        .toList();
    List<Mission> picked = activeMissions
        .where((m) => m.status == MissionStatus.pickedUp)
        .toList();

    List<RouteStep> bestRoute;

    // For small number of total stops, we can find the absolute optimal route.
    if (activeMissions.length <= _optimalSearchLimit) {
      bestRoute = _findOptimalRoute(start, waiting, picked);
    } else {
      bestRoute = _findGreedyRoute(start, waiting, picked);
      bestRoute = _optimizeRoute(start, bestRoute);
    }

    return bestRoute;
  }

  /// Brute force search with pruning for the optimal PDP route.
  static List<RouteStep> _findOptimalRoute(
    Location start,
    List<Mission> waitingMissions,
    List<Mission> alreadyPickedMissions,
  ) {
    List<RouteStep> bestRoute = [];
    double minDistance = double.infinity;

    void backtrack(
      Location currentLoc,
      List<Mission> waiting,
      List<Mission> picked,
      List<RouteStep> currentRoute,
      double currentDist,
    ) {
      // Pruning
      if (currentDist >= minDistance) return;

      if (waiting.isEmpty && picked.isEmpty) {
        if (currentDist < minDistance) {
          minDistance = currentDist;
          bestRoute = List.from(currentRoute);
        }
        return;
      }

      // Try picking up
      for (int i = 0; i < waiting.length; i++) {
        Mission m = waiting[i];
        double d = currentLoc.distanceTo(m.source);

        currentRoute.add(RouteStep(Action.pickUp, m));

        final nextWaiting = List<Mission>.from(waiting)..removeAt(i);
        final nextPicked = List<Mission>.from(picked)..add(m);

        backtrack(
          m.source,
          nextWaiting,
          nextPicked,
          currentRoute,
          currentDist + d,
        );
        currentRoute.removeLast();
      }

      // Try delivering
      for (int i = 0; i < picked.length; i++) {
        Mission m = picked[i];
        double d = currentLoc.distanceTo(m.destination);

        currentRoute.add(RouteStep(Action.deliver, m));

        final nextPicked = List<Mission>.from(picked)..removeAt(i);

        backtrack(
          m.destination,
          waiting,
          nextPicked,
          currentRoute,
          currentDist + d,
        );
        currentRoute.removeLast();
      }
    }

    backtrack(
      start,
      List.from(waitingMissions),
      List.from(alreadyPickedMissions),
      [],
      0,
    );
    return bestRoute;
  }

  /// Standard Nearest Neighbor greedy algorithm.
  static List<RouteStep> _findGreedyRoute(
    Location start,
    List<Mission> waitingMissions,
    List<Mission> alreadyPickedMissions,
  ) {
    List<RouteStep> route = [];
    List<Mission> waiting = List.from(waitingMissions);
    List<Mission> picked = List.from(alreadyPickedMissions);
    Location currentLoc = start;

    while (waiting.isNotEmpty || picked.isNotEmpty) {
      double minD = double.infinity;
      Mission? bestM;
      Action? bestA;

      // Check all available pickups
      for (var m in waiting) {
        double d = currentLoc.distanceTo(m.source);
        if (d < minD) {
          minD = d;
          bestM = m;
          bestA = Action.pickUp;
        }
      }

      // Check all available deliveries
      for (var m in picked) {
        double d = currentLoc.distanceTo(m.destination);
        if (d < minD) {
          minD = d;
          bestM = m;
          bestA = Action.deliver;
        }
      }

      if (bestM == null) break;

      route.add(RouteStep(bestA!, bestM));
      if (bestA == Action.pickUp) {
        waiting.remove(bestM);
        picked.add(bestM);
        currentLoc = bestM.source;
      } else {
        picked.remove(bestM);
        currentLoc = bestM.destination;
      }
    }

    return route;
  }

  /// Simple local search (2-opt style) to improve the route.
  /// Note: constraints must be maintained (Pick-up before Delivery).
  static List<RouteStep> _optimizeRoute(Location start, List<RouteStep> route) {
    if (route.length < 4) return route;

    bool improved = true;
    List<RouteStep> bestRoute = List.from(route);
    double currentBestDist = _totalDistance(start, bestRoute);

    while (improved) {
      improved = false;
      for (int i = 0; i < bestRoute.length - 1; i++) {
        for (int j = i + 1; j < bestRoute.length; j++) {
          List<RouteStep> candidate = _swap(bestRoute, i, j);
          if (_isValidRoute(candidate)) {
            double newDist = _totalDistance(start, candidate);
            if (newDist < currentBestDist - 0.001) {
              bestRoute = candidate;
              currentBestDist = newDist;
              improved = true;
            }
          }
        }
      }
    }
    return bestRoute;
  }

  static List<RouteStep> _swap(List<RouteStep> list, int i, int j) {
    List<RouteStep> next = List.from(list);
    RouteStep temp = next[i];
    next[i] = next[j];
    next[j] = temp;
    return next;
  }

  static bool _isValidRoute(List<RouteStep> route) {
    Map<String, bool> pickedUp = {};
    for (var step in route) {
      if (step.action == Action.pickUp) {
        pickedUp[step.mission.id] = true;
      } else {
        if (pickedUp[step.mission.id] != true) {
          if (step.mission.status != MissionStatus.pickedUp) return false;
        }
      }
    }
    return true;
  }

  static double _totalDistance(Location start, List<RouteStep> route) {
    double dist = 0;
    Location current = start;
    for (var step in route) {
      dist += current.distanceTo(step.location);
      current = step.location;
    }
    return dist;
  }

  /// Benchmarks both algorithms and returns a summary.
  static Map<String, dynamic> benchmark(
    List<Mission> missions,
    Location start,
  ) {
    // Identify missions already picked up
    List<Mission> waiting = missions
        .where((m) => m.status != MissionStatus.pickedUp)
        .toList();
    List<Mission> picked = missions
        .where((m) => m.status == MissionStatus.pickedUp)
        .toList();

    final sw = Stopwatch()..start();
    final optRoute = _findOptimalRoute(start, waiting, picked);
    sw.stop();
    final optTime = sw.elapsedMicroseconds / 1000.0;
    final optDist = _totalDistance(start, optRoute);

    sw.reset();
    sw.start();
    var greedyRoute = _findGreedyRoute(start, waiting, picked);
    greedyRoute = _optimizeRoute(start, greedyRoute);
    sw.stop();
    final greedyTime = sw.elapsedMicroseconds / 1000.0;
    final greedyDist = _totalDistance(start, greedyRoute);

    return {
      'count': missions.length,
      'optimalTime': optTime,
      'optimalDist': optDist,
      'greedyTime': greedyTime,
      'greedyDist': greedyDist,
      'improvement': optDist < greedyDist
          ? ((greedyDist - optDist) / greedyDist * 100)
          : 0.0,
    };
  }
}

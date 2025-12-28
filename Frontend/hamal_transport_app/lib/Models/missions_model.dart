import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'package:hamal_transport_app/Services/routing_service.dart';

class MissionsListsModel {
  final List<Mission> myMissionsList;
  final List<Mission> availableMissionsList;

  // for now we use the mock data
  MissionsListsModel({
    required this.myMissionsList,
    required this.availableMissionsList,
  });

  /// Pre-fetches route info for all missions so it's instantly available.
  /// Call this after missions are loaded.
  Future<void> prefetchRouteInfo({String profile = 'car'}) async {
    final allMissions = [...myMissionsList, ...availableMissionsList];
    // Trigger all route info fetches in parallel (fire-and-forget)
    for (final mission in allMissions) {
      mission.getRouteInfo(profile: profile);
    }
  }

  /// Returns up to [maxResults] missions with the highest heuristic scores.
  ///
  /// The heuristic considers:
  /// - Mission age: older missions are prioritized (higher urgency)
  /// - Route distance: shorter distances score higher (more efficient)
  /// - Route duration: shorter durations score higher (quicker to complete)
  static Future<List<Mission>> getTopSuggestedMissions(
    List<Mission> missions, {
    int maxResults = 3,
    double ageWeight = 0.4,
    double distanceWeight = 0.3,
    double durationWeight = 0.3,
  }) async {
    if (missions.isEmpty) return [];

    // Calculate scores for all missions
    final scoredMissions = <_ScoredMission>[];

    for (final mission in missions) {
      final score = await _calculateHeuristicScore(
        mission,
        ageWeight: ageWeight,
        distanceWeight: distanceWeight,
        durationWeight: durationWeight,
      );
      scoredMissions.add(_ScoredMission(mission: mission, score: score));
    }

    scoredMissions.sort((a, b) => b.score.compareTo(a.score));

    // Return top results
    return scoredMissions.take(maxResults).map((sm) => sm.mission).toList();
  }

  /// Calculates a heuristic score for a single mission.
  static Future<double> _calculateHeuristicScore(
    Mission mission, {
    required double ageWeight,
    required double distanceWeight,
    required double durationWeight,
  }) async {
    double score = 0.0;

    // Age score: days since mission was created (older = higher score)
    final now = DateTime.now();
    final ageInDays = now.difference(mission.time).inDays.abs();
    // Normalize: cap at 30 days, scale 0-100
    final normalizedAge = (ageInDays.clamp(0, 30) / 30) * 100;
    score += normalizedAge * ageWeight;

    // Route info score (distance & duration)
    final routeInfo = await mission.getRouteInfo(profile: 'car');

    if (routeInfo != null) {
      // Distance score: shorter = higher score
      // Normalize: assume max distance ~100km, invert so shorter = higher
      final distanceKm = routeInfo.distanceKm;
      final normalizedDistance = ((100 - distanceKm.clamp(0, 100)) / 100) * 100;
      score += normalizedDistance * distanceWeight;

      // Duration score: shorter = higher score
      // Normalize: assume max duration ~120 minutes, invert so shorter = higher
      final durationMinutes = routeInfo.durationMinutes;
      final normalizedDuration =
          ((120 - durationMinutes.clamp(0, 120)) / 120) * 100;
      score += normalizedDuration * durationWeight;
    } else {
      score += 50 * distanceWeight;
      score += 50 * durationWeight;
    }

    return score;
  }

  static Comparator getSortComperator(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.distanceClosestFirst:
        return (a, b) {
          final distanceA = a.source.distanceTo(a.destination);
          final distanceB = b.source.distanceTo(b.destination);
          return distanceA.compareTo(distanceB);
        };
      case SortBy.distanceFurthestFirst:
        return (a, b) {
          final distanceA = a.source.distanceTo(a.destination);
          final distanceB = b.source.distanceTo(b.destination);
          return distanceB.compareTo(distanceA);
        };
      case SortBy.timeOldestFirst:
        return (a, b) => a.time.compareTo(b.time);
      case SortBy.timeNewestFirst:
        return (a, b) => b.time.compareTo(a.time);
    }
  }

  static bool Function(Mission) getFilterFunction(FilterBy filterBy) {
    switch (filterBy) {
      case FilterBy.noFilter:
        return (a) => true;
      case FilterBy.chosenOnly:
        return (a) => a.status == MissionStatus.chosen;
      case FilterBy.pickedUpOnly:
        return (a) => a.status == MissionStatus.pickedUp;
    }
  }

  static String getSortBy(BuildContext context, SortBy sortby) {
    final l10n = AppLocalizations.of(context)!;
    switch (sortby) {
      case SortBy.distanceClosestFirst:
        return l10n.closestToFurthest;
      case SortBy.distanceFurthestFirst:
        return l10n.furthestToClosest;
      case SortBy.timeOldestFirst:
        return l10n.oldestToNewest;
      case SortBy.timeNewestFirst:
        return l10n.newestToOldest;
    }
  }

  static String getFilterBy(BuildContext context, FilterBy filterBy) {
    final l10n = AppLocalizations.of(context)!;
    switch (filterBy) {
      case FilterBy.noFilter:
        return l10n.noFilter;
      case FilterBy.chosenOnly:
        return l10n.chosenFilter;
      case FilterBy.pickedUpOnly:
        return l10n.pickedUpFilter;
    }
  }
}

enum SortBy {
  distanceClosestFirst,
  distanceFurthestFirst,
  timeOldestFirst,
  timeNewestFirst,
}

enum FilterBy { noFilter, chosenOnly, pickedUpOnly }

/// Helper class to pair a mission with its heuristic score.
class _ScoredMission {
  final Mission mission;
  final double score;

  _ScoredMission({required this.mission, required this.score});
}

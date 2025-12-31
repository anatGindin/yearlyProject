import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';

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
  /// The heuristic uses ranking-based scoring:
  /// - Mission age rank: older missions get higher ranks (higher urgency)
  /// - Route efficiency rank: shorter duration gets higher ranks
  /// Final score is weighted average of ranks (1 to n scale).
  static Future<List<Mission>> getTopSuggestedMissions(
    List<Mission> missions, {
    int maxResults = 3,
    double ageWeight = 0.7,
    double routeEfficiencyWeight = 0.3,
  }) async {
    if (missions.isEmpty) return [];

    final n = missions.length;

    // Collect age and duration data for all missions
    final missionData = <_MissionRankData>[];
    for (final mission in missions) {
      final ageInDays = DateTime.now().difference(mission.time).inDays.abs();
      final routeInfo = await mission.getRouteInfo(profile: 'car');
      final durationMinutes = routeInfo?.durationMinutes ?? double.maxFinite;
      missionData.add(
        _MissionRankData(
          mission: mission,
          ageInDays: ageInDays,
          durationMinutes: durationMinutes,
        ),
      );
    }

    // Rank by age (oldest first gets highest rank = n)
    final byAge = List<_MissionRankData>.from(missionData)
      ..sort((a, b) => b.ageInDays.compareTo(a.ageInDays));
    for (var i = 0; i < byAge.length; i++) {
      byAge[i].ageRank = n - i; // oldest gets rank n, newest gets rank 1
    }

    // Rank by duration (shortest first gets highest rank = n)
    final byDuration = List<_MissionRankData>.from(missionData)
      ..sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
    for (var i = 0; i < byDuration.length; i++) {
      byDuration[i].durationRank =
          n - i; // shortest gets rank n, longest gets rank 1
    }

    // Calculate weighted score from ranks
    for (final data in missionData) {
      data.score =
          data.ageRank * ageWeight + data.durationRank * routeEfficiencyWeight;
    }

    // Sort by score descending
    missionData.sort((a, b) => b.score.compareTo(a.score));

    // Return top results
    return missionData.take(maxResults).map((d) => d.mission).toList();
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

/// Helper class to store mission data for ranking-based scoring.
class _MissionRankData {
  final Mission mission;
  final int ageInDays;
  final double durationMinutes;
  int ageRank = 0;
  int durationRank = 0;
  double score = 0;

  _MissionRankData({
    required this.mission,
    required this.ageInDays,
    required this.durationMinutes,
  });
}

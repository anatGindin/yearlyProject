import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';

class MissionsListsModel {
  // Private constructor to prevent instantiation
  MissionsListsModel._();

  /// Returns up to [maxResults] missions with the highest heuristic scores,
  /// along with the additional distance each mission would add.
  ///
  /// The heuristic uses ranking-based scoring:
  /// - Mission age rank: older missions get higher ranks (higher urgency)
  /// - Additional distance rank: missions that add less distance to the
  ///   chosen mission route get higher ranks (more efficient)
  ///
  /// Additional distance = distance from mission.source to chosenMission.source
  ///                     + distance from mission.destination to chosenMission.destination
  ///
  /// Final score is weighted average of ranks (1 to n scale).
  static List<SuggestedMission> getTopSuggestedMissions(
    List<Mission> missions, {
    required Mission chosenMission,
    int maxResults = 3,
    double ageWeight = 0.3,
    double additionalDistanceWeight = 0.7,
  }) {
    if (missions.isEmpty) return [];

    final n = missions.length;

    // Collect age and additional distance data for all missions
    final missionData = <_MissionRankData>[];
    for (final mission in missions) {
      final ageInDays = DateTime.now().difference(mission.time).inDays.abs();

      // Calculate additional distance using Haversine formula:
      // Distance from mission source to chosen mission source
      // + Distance from mission destination to chosen mission destination
      final sourceToSourceKm = mission.source.distanceTo(chosenMission.source);
      final destToDestKm = mission.destination.distanceTo(
        chosenMission.destination,
      );
      final additionalDistanceKm = sourceToSourceKm + destToDestKm;

      missionData.add(
        _MissionRankData(
          mission: mission,
          ageInDays: ageInDays,
          additionalDistanceKm: additionalDistanceKm,
        ),
      );
    }

    // Rank by age (oldest first gets highest rank = n)
    final byAge = List<_MissionRankData>.from(missionData)
      ..sort((a, b) => b.ageInDays.compareTo(a.ageInDays));
    for (var i = 0; i < byAge.length; i++) {
      byAge[i].ageRank = n - i;
    }

    // Rank by additional distance (shortest first gets highest rank = n)
    final byAdditionalDistance = List<_MissionRankData>.from(
      missionData,
    )..sort((a, b) => a.additionalDistanceKm.compareTo(b.additionalDistanceKm));
    for (var i = 0; i < byAdditionalDistance.length; i++) {
      byAdditionalDistance[i].additionalDistanceRank = n - i;
    }

    // Calculate weighted score from ranks
    for (final data in missionData) {
      data.score =
          data.ageRank * ageWeight +
          data.additionalDistanceRank * additionalDistanceWeight;
    }

    // Sort by score descending
    missionData.sort((a, b) => b.score.compareTo(a.score));

    // Return top results with additional distance info
    return missionData
        .take(maxResults)
        .map(
          (d) => SuggestedMission(
            mission: d.mission,
            additionalDistanceKm: d.additionalDistanceKm,
          ),
        )
        .toList();
  }

  static Comparator<Mission> getSortComperator(
    SortBy sortBy, {
    Location? userLocation,
  }) {
    switch (sortBy) {
      case SortBy.distanceClosestFirst:
        return (Mission a, Mission b) {
          final distanceA = a.source.distanceTo(a.destination);
          final distanceB = b.source.distanceTo(b.destination);
          return distanceA.compareTo(distanceB);
        };
      case SortBy.distanceFurthestFirst:
        return (Mission a, Mission b) {
          final distanceA = a.source.distanceTo(a.destination);
          final distanceB = b.source.distanceTo(b.destination);
          return distanceB.compareTo(distanceA);
        };
      case SortBy.distanceToUserClosestFirst:
        return (Mission a, Mission b) {
          final distanceA =
              userLocation?.distanceTo(a.destination) ??
              a.source.distanceTo(a.destination);
          final distanceB =
              userLocation?.distanceTo(b.destination) ??
              b.source.distanceTo(b.destination);
          return distanceA.compareTo(distanceB);
        };
      case SortBy.distanceToUserFurthestFirst:
        return (Mission a, Mission b) {
          final distanceA =
              userLocation?.distanceTo(a.destination) ??
              a.source.distanceTo(a.destination);
          final distanceB =
              userLocation?.distanceTo(b.destination) ??
              b.source.distanceTo(b.destination);
          return distanceB.compareTo(distanceA);
        };
      case SortBy.timeOldestFirst:
        return (Mission a, Mission b) => a.time.compareTo(b.time);
      case SortBy.timeNewestFirst:
        return (Mission a, Mission b) => b.time.compareTo(a.time);
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
}

enum SortBy {
  distanceClosestFirst,
  distanceFurthestFirst,
  distanceToUserClosestFirst,
  distanceToUserFurthestFirst,
  timeOldestFirst,
  timeNewestFirst;

  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case SortBy.distanceClosestFirst:
        return l10n.closestToFurthest;
      case SortBy.distanceFurthestFirst:
        return l10n.furthestToClosest;
      case SortBy.distanceToUserClosestFirst:
        return l10n.distanceFromYouClosest;
      case SortBy.distanceToUserFurthestFirst:
        return l10n.distanceFromYouFurthest;
      case SortBy.timeOldestFirst:
        return l10n.oldestToNewest;
      case SortBy.timeNewestFirst:
        return l10n.newestToOldest;
    }
  }
}

enum FilterBy {
  noFilter,
  chosenOnly,
  pickedUpOnly;

  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case FilterBy.noFilter:
        return l10n.noFilter;
      case FilterBy.chosenOnly:
        return l10n.menuChosenFilter;
      case FilterBy.pickedUpOnly:
        return l10n.menuPickedUpFilter;
    }
  }
}

/// Represents a suggested mission with its additional distance.
class SuggestedMission {
  final Mission mission;
  final double additionalDistanceKm;

  SuggestedMission({required this.mission, required this.additionalDistanceKm});
}

/// Helper class to store mission data for ranking-based scoring.
class _MissionRankData {
  final Mission mission;
  final int ageInDays;
  final double additionalDistanceKm;
  int ageRank = 0;
  int additionalDistanceRank = 0;
  double score = 0;

  _MissionRankData({
    required this.mission,
    required this.ageInDays,
    required this.additionalDistanceKm,
  });
}

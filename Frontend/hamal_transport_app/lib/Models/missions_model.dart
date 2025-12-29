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
        return l10n.menuChosenFilter;
      case FilterBy.pickedUpOnly:
        return l10n.menuPickedUpFilter;
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

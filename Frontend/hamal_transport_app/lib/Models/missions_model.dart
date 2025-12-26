import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';

class MissionsListsModel {
  final List<Mission> myMissionsList;
  final List<Mission> availableMissionsList;

  // for now we use the mock data
  MissionsListsModel({
    required this.myMissionsList,
    required this.availableMissionsList,
  });

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
      case SortBy.distanceGPSClosestFirst:
        return (Mission a, Mission b) {
          final distanceA =
              userLocation?.distanceTo(a.source) ??
              a.source.distanceTo(a.destination);
          final distanceB =
              userLocation?.distanceTo(b.source) ??
              b.source.distanceTo(b.destination);
          return distanceA.compareTo(distanceB);
        };
      case SortBy.distanceGPSFurthestFirst:
        return (Mission a, Mission b) {
          final distanceA =
              userLocation?.distanceTo(a.source) ??
              a.source.distanceTo(a.destination);
          final distanceB =
              userLocation?.distanceTo(b.source) ??
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

  static String getSortBy(BuildContext context, SortBy sortby) {
    final l10n = AppLocalizations.of(context)!;
    switch (sortby) {
      case SortBy.distanceClosestFirst:
        return l10n.closestToFurthest;
      case SortBy.distanceFurthestFirst:
        return l10n.furthestToClosest;
      case SortBy.distanceGPSClosestFirst:
        return l10n.closestToFurthestGps;
      case SortBy.distanceGPSFurthestFirst:
        return l10n.furthestToClosestGps;
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
  distanceGPSClosestFirst,
  distanceGPSFurthestFirst,
  timeOldestFirst,
  timeNewestFirst,
}

enum FilterBy { noFilter, chosenOnly, pickedUpOnly }

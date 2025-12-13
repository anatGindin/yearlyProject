import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:hamal_transport_app/ViewModels/my_missions_view_model.dart';

void main() {
  group('MyMissionsViewModel Sorting & Filtering', () {
    late MissionsListsModel missionsLists;
    late MyMissionsViewModel myVM;

    setUp(() {
      // create data model
      missionsLists = MissionsListsModel(
        myMissionsList: sampleMissions,
        availableMissionsList: availableMissions,
      );

      // Create ViewModels with initial state
      myVM = MyMissionsViewModel(missionsLists);
      sampleMissions[0].status = 'chosen';
      sampleMissions[1].status = 'chosen';
      sampleMissions[2].status = 'picked up';
    });
    test('sort by furthest to closest', () {
      myVM.sortBy(SortBy.distanceFurthestFirst);

      final missions = myVM.myMissions;
      expect(
        missions.first.location.compareTo(missions.last.location) > 0,
        true,
      );
    });
    test('sort by closest to furthest', () {
      myVM.sortBy(SortBy.distanceClosestFirst);

      final missions = myVM.myMissions;
      expect(
        missions.first.location.compareTo(missions.last.location) < 0,
        true,
      );
    });
    test('sort by newest to oldest', () {
      myVM.sortBy(SortBy.timeNewestFirst);

      final missions = myVM.myMissions;
      expect(missions.first.time.isAfter(missions.last.time), true);
    });

    test('sort by oldest to newest', () {
      myVM.sortBy(SortBy.timeOldestFirst);

      final missions = myVM.myMissions;
      expect(missions.first.time.isBefore(missions.last.time), true);
    });

    test('filter chosen only', () {
      myVM.filterBy(FilterBy.chosenOnly);

      final missions = myVM.myMissions;
      expect(missions.every((m) => m.status == 'chosen'), true);
    });

    test('filter picked up only', () {
      myVM.filterBy(FilterBy.pickedUpOnly);

      final missions = myVM.myMissions;
      expect(missions.every((m) => m.status == 'picked up'), true);
    });

    test('combined filter + sort', () {
      myVM.filterBy(FilterBy.chosenOnly);
      myVM.sortBy(SortBy.timeOldestFirst);

      final missions = myVM.myMissions;
      expect(missions.length, 2); // adjust based on mock data
      expect(missions.first.time.isBefore(missions.last.time), true);
    });
  });

  group('AvailableMissionsViewModel Sorting & Filtering', () {
    late MissionsListsModel missionsLists;
    late AvailableMissionsViewModel availVM;

    setUp(() {
      // create data model
      missionsLists = MissionsListsModel(
        myMissionsList: sampleMissions,
        availableMissionsList: availableMissions,
      );

      // Create ViewModels with initial state
      availVM = AvailableMissionsViewModel(missionsLists);
    });
    test('sort by furthest to closest', () {
      availVM.sortBy(SortBy.distanceFurthestFirst);

      final missions = availVM.availableMissions;
      expect(
        missions.first.location.compareTo(missions.last.location) > 0,
        true,
      );
    });
    test('sort by closest to furthest', () {
      availVM.sortBy(SortBy.distanceClosestFirst);

      final missions = availVM.availableMissions;
      expect(
        missions.first.location.compareTo(missions.last.location) < 0,
        true,
      );
    });
    test('sort by newest to oldest', () {
      availVM.sortBy(SortBy.timeNewestFirst);

      final missions = availVM.availableMissions;
      expect(missions.first.time.isAfter(missions.last.time), true);
    });

    test('sort by oldest to newest', () {
      availVM.sortBy(SortBy.timeOldestFirst);

      final missions = availVM.availableMissions;
      expect(missions.first.time.isBefore(missions.last.time), true);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:hamal_transport_app/ViewModels/my_missions_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeMockData();
  });

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
      sampleMissions[0].status = MissionStatus.chosen;
      sampleMissions[1].status = MissionStatus.chosen;
      sampleMissions[2].status = MissionStatus.pickedUp;
    });
    test('sort by furthest to closest', () {
      myVM.sortBy(SortBy.distanceFurthestFirst);

      final missions = myVM.myMissions;
      final firstDistance = missions.first.source.distanceTo(
        missions.first.destination,
      );
      final lastDistance = missions.last.source.distanceTo(
        missions.last.destination,
      );
      expect(firstDistance > lastDistance, true);
    });
    test('sort by closest to furthest', () {
      myVM.sortBy(SortBy.distanceClosestFirst);

      final missions = myVM.myMissions;
      final firstDistance = missions.first.source.distanceTo(
        missions.first.destination,
      );
      final lastDistance = missions.last.source.distanceTo(
        missions.last.destination,
      );
      expect(firstDistance < lastDistance, true);
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
      expect(missions.every((m) => m.status == MissionStatus.chosen), true);
    });

    test('filter picked up only', () {
      myVM.filterBy(FilterBy.pickedUpOnly);

      final missions = myVM.myMissions;
      expect(missions.every((m) => m.status == MissionStatus.pickedUp), true);
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
      final firstDistance = missions.first.source.distanceTo(
        missions.first.destination,
      );
      final lastDistance = missions.last.source.distanceTo(
        missions.last.destination,
      );
      expect(firstDistance > lastDistance, true);
    });
    test('sort by closest to furthest', () {
      availVM.sortBy(SortBy.distanceClosestFirst);

      final missions = availVM.availableMissions;
      final firstDistance = missions.first.source.distanceTo(
        missions.first.destination,
      );
      final lastDistance = missions.last.source.distanceTo(
        missions.last.destination,
      );
      expect(firstDistance < lastDistance, true);
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

  group('GPS Sorting Comparator', () {
    test('distanceGPSClosestFirst sorts by user -> source distance', () {
      final userLocation = Location(
        name: 'User',
        latitude: 32.0853,
        longitude: 34.7818,
      );

      final missions = sampleMissions.toList()
        ..sort(
          MissionsListsModel.getSortComperator(
            SortBy.distanceGPSClosestFirst,
            userLocation: userLocation,
          ),
        );

      final firstDistance = userLocation.distanceTo(missions.first.source);
      final lastDistance = userLocation.distanceTo(missions.last.source);
      expect(firstDistance <= lastDistance, true);
    });

    test('distanceGPSFurthestFirst sorts by user -> source distance', () {
      final userLocation = Location(
        name: 'User',
        latitude: 32.0853,
        longitude: 34.7818,
      );

      final missions = sampleMissions.toList()
        ..sort(
          MissionsListsModel.getSortComperator(
            SortBy.distanceGPSFurthestFirst,
            userLocation: userLocation,
          ),
        );

      final firstDistance = userLocation.distanceTo(missions.first.source);
      final lastDistance = userLocation.distanceTo(missions.last.source);
      expect(firstDistance >= lastDistance, true);
    });
  });
}

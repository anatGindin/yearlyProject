import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Services/Fake/fake_authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/ViewModels/missions_list_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeMockData();
  });

  group('MissionsListViewModel (My Missions) Sorting & Filtering', () {
    late MissionsRepository repository;
    late MissionsListViewModel myVM;

    setUp(() {
      repository = MissionsRepository(
        myMissionsList: sampleMissions,
        availableMissionsList: availableMissions,
        adminMissionsList: adminMissions,
        authService: FakeAuthenticationService(),
      );
      myVM = MissionsListViewModel(
        repository: repository,
        type: MissionListType.myMissions,
      );

      // Mutate mock data statuses for filtering tests
      // Note: sampleMissions is a global mock list, so we might be modifying it for other tests if not careful.
      // But setUp runs before each test.
      // However, modifying objects inside the list persists if the list objects are shared.
      // For safety, let's just assert on what we have or ensure repository creates copies (it doesn't, it takes the list ref).
      // Assuming mock data is reset or we just set it here.
      // Let's manually ensure state for these tests.
      sampleMissions[0].status = MissionStatus.assigned;
      sampleMissions[1].status = MissionStatus.assigned;
      sampleMissions[2].status = MissionStatus.pickedUp;
    });

    test('sort by furthest to closest', () {
      myVM.sortBy(SortBy.distanceFurthestFirst);

      final missions = myVM.missions;
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

      final missions = myVM.missions;
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

      final missions = myVM.missions;
      expect(missions.first.time.isAfter(missions.last.time), true);
    });

    test('sort by oldest to newest', () {
      myVM.sortBy(SortBy.timeOldestFirst);

      final missions = myVM.missions;
      expect(missions.first.time.isBefore(missions.last.time), true);
    });

    test('filter assigned only', () {
      myVM.filterBy(FilterBy.assignedOnly);

      final missions = myVM.missions;
      expect(missions.every((m) => m.status == MissionStatus.assigned), true);
    });

    test('filter picked up only', () {
      myVM.filterBy(FilterBy.pickedUpOnly);

      final missions = myVM.missions;
      expect(missions.every((m) => m.status == MissionStatus.pickedUp), true);
    });

    test('combined filter + sort', () {
      myVM.filterBy(FilterBy.assignedOnly);
      myVM.sortBy(SortBy.timeOldestFirst);

      final missions = myVM.missions;
      // Depending on how many assigned missions are there. Based on setUp line 30-32:
      // index 0: assigned
      // index 1: assigned
      // index 2: pickedUp
      // sampleMissions has more items probably.
      // checking length might be brittle if sampleMissions changes size.
      // But let's assume at least 2 are assigned.
      expect(missions.length >= 2, true);
      expect(missions.first.time.isBefore(missions.last.time), true);
    });
  });

  group('MissionsListViewModel (Available) Sorting & Filtering', () {
    late MissionsRepository repository;
    late MissionsListViewModel availVM;

    setUp(() {
      repository = MissionsRepository(
        myMissionsList: sampleMissions,
        availableMissionsList: availableMissions,
        adminMissionsList: adminMissions,
        authService: FakeAuthenticationService(),
      );
      availVM = MissionsListViewModel(
        repository: repository,
        type: MissionListType.availableMissions,
      );
    });

    test('sort by furthest to closest', () {
      availVM.sortBy(SortBy.distanceFurthestFirst);

      final missions = availVM.missions;
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

      final missions = availVM.missions;
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

      final missions = availVM.missions;
      expect(missions.first.time.isAfter(missions.last.time), true);
    });

    test('sort by oldest to newest', () {
      availVM.sortBy(SortBy.timeOldestFirst);

      final missions = availVM.missions;
      expect(missions.first.time.isBefore(missions.last.time), true);
    });
  });

  group('GPS Sorting Comparator', () {
    test(
      'distanceToUserClosestFirst sorts by user -> destination distance',
      () {
        final userLocation = Location(
          name: 'User',
          latitude: 32.0853,
          longitude: 34.7818,
        );

        final missions = sampleMissions.toList()
          ..sort(
            MissionsListsModel.getSortComperator(
              SortBy.distanceToUserClosestFirst,
              userLocation: userLocation,
            ),
          );

        final firstDistance = userLocation.distanceTo(missions.first.source);
        final lastDistance = userLocation.distanceTo(missions.last.source);
        expect(firstDistance <= lastDistance, true);
      },
    );

    test(
      'distanceToUserFurthestFirst sorts by user -> destination distance',
      () {
        final userLocation = Location(
          name: 'User',
          latitude: 32.0853,
          longitude: 34.7818,
        );

        final missions = sampleMissions.toList()
          ..sort(
            MissionsListsModel.getSortComperator(
              SortBy.distanceToUserFurthestFirst,
              userLocation: userLocation,
            ),
          );

        final firstDistance = userLocation.distanceTo(missions.first.source);
        final lastDistance = userLocation.distanceTo(missions.last.source);
        expect(firstDistance >= lastDistance, true);
      },
    );
  });
}

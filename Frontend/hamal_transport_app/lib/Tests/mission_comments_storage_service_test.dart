import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Models/contact.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/Fake/fake_authentication_service.dart';
import 'package:hamal_transport_app/Services/mission_comments_storage_service.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/ViewModels/mission_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  setUp(() {
    MissionsRepository.reset();
  });
  group('MissionCommentsStorage', () {
    const missionId = 'test_mission_1';

    test('readComments returns empty list when no comments saved', () async {
      final comments = await MissionCommentsStorage.readComments(missionId);
      expect(comments, isEmpty);
    });

    test('writeComments and readComments round-trip', () async {
      final input = ['comment 1', 'comment 2', 'comment 3'];
      await MissionCommentsStorage.writeComments(missionId, input);
      final output = await MissionCommentsStorage.readComments(missionId);
      expect(output, equals(input));
      await MissionCommentsStorage.clearComments(missionId);
    });

    test('clearComments removes all comments for mission', () async {
      await MissionCommentsStorage.writeComments(missionId, ['a', 'b']);
      await MissionCommentsStorage.clearComments(missionId);
      final comments = await MissionCommentsStorage.readComments(missionId);
      expect(comments, isEmpty);
    });

    test('clearComments does not affect other missions', () async {
      await MissionCommentsStorage.writeComments('mission_A', ['a', 'b']);
      await MissionCommentsStorage.writeComments('mission_B', ['c', 'd']);
      await MissionCommentsStorage.clearComments('mission_A');
      final remaining = await MissionCommentsStorage.readComments('mission_B');
      expect(remaining, equals(['c', 'd']));
      await MissionCommentsStorage.clearComments('mission_B');
    });

    test('loadCommentsIntoMission populates mission.comments', () async {
      await MissionCommentsStorage.writeComments(missionId, ['hello', 'world']);
      final mission = _makeMission(missionId);
      await MissionCommentsStorage.loadCommentsIntoMission(mission);
      expect(mission.comments, equals(['hello', 'world']));
      await MissionCommentsStorage.clearComments(missionId);
    });

    test('saveCommentsFromMission persists mission.comments', () async {
      final mission = _makeMission(missionId)..comments = ['saved comment'];
      await MissionCommentsStorage.saveCommentsFromMission(mission);
      final stored = await MissionCommentsStorage.readComments(missionId);
      expect(stored, equals(['saved comment']));
      await MissionCommentsStorage.clearComments(missionId);
    });

    test('missions with different ids do not share comments', () async {
      await MissionCommentsStorage.writeComments('m1', ['for m1']);
      await MissionCommentsStorage.writeComments('m2', ['for m2']);
      expect(
        await MissionCommentsStorage.readComments('m1'),
        equals(['for m1']),
      );
      expect(
        await MissionCommentsStorage.readComments('m2'),
        equals(['for m2']),
      );
      await MissionCommentsStorage.clearComments('m1');
      await MissionCommentsStorage.clearComments('m2');
    });
  });

  test('comments are cleared when mission is delivered', () async {
    await MissionCommentsStorage.writeComments('m1', ['a', 'b']);
    final mission = _makeMission('m1');
    final vm = FakeMissionViewModel(mission, _mockRepository);

    vm.updateStatus(MissionStatus.delivered);

    final comments = await MissionCommentsStorage.readComments('m1');
    expect(comments, isEmpty);
  });

  test(
    'comments are cleared when mission is cancelled via updateStatus',
    () async {
      await MissionCommentsStorage.writeComments('m1', ['a', 'b']);
      final mission = _makeMission('m1');
      final vm = FakeMissionViewModel(mission, _mockRepository);

      vm.updateStatus(MissionStatus.cancelled);

      final comments = await MissionCommentsStorage.readComments('m1');
      expect(comments, isEmpty);
    },
  );

  test(
    'comments are cleared when mission is cancelled via cancelMission',
    () async {
      await MissionCommentsStorage.writeComments('m1', ['a', 'b']);
      final mission = _makeMission('m1');
      final vm = FakeMissionViewModel(mission, _mockRepository);

      vm.cancelMission('wrong address');

      final comments = await MissionCommentsStorage.readComments('m1');
      expect(comments, isEmpty);
    },
  );

  test('comments are NOT cleared when mission is picked up', () async {
    await MissionCommentsStorage.writeComments('m1', ['a', 'b']);
    final mission = _makeMission('m1');
    final vm = FakeMissionViewModel(mission, _mockRepository);

    vm.updateStatus(MissionStatus.pickedUp);

    final comments = await MissionCommentsStorage.readComments('m1');
    expect(comments, equals(['a', 'b']));
    await MissionCommentsStorage.clearComments('m1');
  });
}

Mission _makeMission(String id) => Mission(
  id: id,
  source: Location(name: 'A', latitude: 0, longitude: 0),
  destination: Location(name: 'B', latitude: 0, longitude: 0),
  description: 'test',
  sourceContact: Contact(fullName: 'S', phoneNumber: '000'),
  destinationContact: Contact(fullName: 'D', phoneNumber: '111'),
  time: DateTime.now(),
  comments: [],
  carType: CarType.private,
);

final _mockRepository = MissionsRepository(
  authService: FakeAuthenticationService(),
);

class FakeMissionViewModel extends MissionViewModel {
  FakeMissionViewModel(super.mission, super.repository);

  @override
  void initUserRole() {
    userRole = UserRole.driver;
    isLoading = false;
    notifyListeners();
  }
}

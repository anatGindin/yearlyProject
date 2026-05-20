import 'package:mockito/mockito.dart';
import '../backend_service.dart';
import '../../Models/mission.dart';

class MockMissionService extends Mock implements MissionService {
  final List<Mission> _missions;

  MockMissionService({List<Mission> missions = const []})
    : _missions = missions;

  // load missions is the only thing we need SO FAR
  @override
  Future<List<Mission>> getMissions(
    MissionStatus? status,
    String? driverId,
  ) async {
    return _missions;
  }
}

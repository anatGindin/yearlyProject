import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'package:hamal_transport_app/Models/mission.dart';

class MissionsListsModel {
  final List<Mission> myMissionsList;
  final List<Mission> availableMissionsList;

  // for now we use the mock data
  MissionsListsModel({
    List<Mission>? myMissionsList,
    List<Mission>? availableMissionsList,
  }) : myMissionsList = myMissionsList ?? sampleMissions,
       availableMissionsList = availableMissionsList ?? availableMissions;
}

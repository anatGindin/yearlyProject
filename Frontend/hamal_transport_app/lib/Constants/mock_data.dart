import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../Models/mission.dart';
import '../Models/user_profile.dart';

// Change the return type to List<dynamic> to accommodate both Mission and UserProfile lists
Future<Map<String, List<dynamic>>> loadMockData() async {
  final String jsonString = await rootBundle.loadString(
    'assets/mock_data.json',
  );
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  final List<Mission> sampleMissions = (jsonData['sampleMissions'] as List)
      .map((missionJson) => Mission.fromJson(missionJson))
      .toList();

  final List<Mission> availableMissions =
      (jsonData['availableMissions'] as List)
          .map((missionJson) => Mission.fromJson(missionJson))
          .toList();

  final List<Mission> adminMissions = (jsonData['adminMissions'] as List)
      .map((missionJson) => Mission.fromJson(missionJson))
      .toList();

  final List<UserProfile> driverUsers = (jsonData['driverUsers'] as List)
      .map((userJson) => UserProfile.fromDictionary(userJson))
      .toList();

  return {
    'sampleMissions': sampleMissions,
    'availableMissions': availableMissions,
    'adminMissions': adminMissions,
    'driverUsers': driverUsers,
  };
}

late List<Mission> sampleMissions;
late List<Mission> availableMissions;
late List<Mission> adminMissions;
late List<UserProfile> driverUsers;

// Initialize mock data variables from JSON file.
Future<void> initializeMockData() async {
  final data = await loadMockData();
  // We cast the dynamic lists back to their specific types
  sampleMissions = List<Mission>.from(data['sampleMissions']!);
  availableMissions = List<Mission>.from(data['availableMissions']!);
  adminMissions = List<Mission>.from(data['adminMissions']!);
  driverUsers = List<UserProfile>.from(data['driverUsers']!);
}

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../Models/mission.dart';

// Load mock data from JSON file
Future<Map<String, List<Mission>>> loadMockData() async {
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

  return {
    'sampleMissions': sampleMissions,
    'availableMissions': availableMissions,
  };
}

late List<Mission> sampleMissions;
late List<Mission> availableMissions;

// Initialize mock data variables from JSON file.
Future<void> initializeMockData() async {
  final data = await loadMockData();
  sampleMissions = data['sampleMissions']!;
  availableMissions = data['availableMissions']!;
}

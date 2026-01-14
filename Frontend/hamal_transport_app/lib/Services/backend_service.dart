import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/mission.dart';

class MissionService {
  final String baseUrl;

  MissionService({required this.baseUrl});

  /// GET /missions?status=&driver_id=
  Future<List<Mission>> getMissions({MissionStatus? status, String? driverId}) async {
    final queryParameters = <String, String>{};
    if (status != null) queryParameters['status'] = status.name;
    if (driverId != null) queryParameters['driver_id'] = driverId;

    final uri = Uri.parse('$baseUrl/missions').replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load missions');
    }

    final List data = json.decode(response.body);
    return data.map((e) => Mission.fromJson(e)).toList();
  }

  /// POST /missions
  Future<Mission> createMission(Mission mission) async {
    final Map<String, dynamic> jsonBody = mission.toJson();
    // remove id because backend generates it
    jsonBody.remove('id');

    final response = await http.post(
      Uri.parse('$baseUrl/missions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jsonBody),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create mission');
    }

    return Mission.fromJson(json.decode(response.body));
  }

  /// PUT /missions/{id}
  Future<Mission> updateMission(Mission mission) async {
    final response = await http.put(
      Uri.parse('$baseUrl/missions/${mission.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(mission.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update mission');
    }

    return Mission.fromJson(json.decode(response.body));
  }

  /// DELETE /missions/{id}
  Future<void> deleteMission(String missionId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/missions/$missionId'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete mission');
    }
  }
}

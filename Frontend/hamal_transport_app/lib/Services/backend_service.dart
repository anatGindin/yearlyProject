import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/mission.dart';
import 'api_client.dart';

class MissionService {
  final String baseUrl;

  MissionService({required this.baseUrl});

  /// GET /missions?status=&driver_id=
  Future<List<Mission>> getMissions({
    MissionStatus? status,
    String? driverId,
  }) async {
    final queryParameters = <String, String>{};

    if (status != null) {
      queryParameters['status'] = status.name;
    }
    if (driverId != null) {
      queryParameters['driver_id'] = driverId;
    }

    final uri = Uri.parse('$baseUrl/missions')
        .replace(queryParameters: queryParameters);

    final response = await ApiClient.safeRequest(
      () => http.get(uri),
    );

    ApiClient.validateSuccess(response, [200]);

    final List data = json.decode(response.body);
    return data.map((e) => Mission.fromJson(e)).toList();
  }

  /// POST /missions
  Future<Mission> createMission(Mission mission) async {
    final Map<String, dynamic> jsonBody = mission.toJson();
    jsonBody.remove('id'); // backend generates id

    final response = await ApiClient.safeRequest(
      () => http.post(
        Uri.parse('$baseUrl/missions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonBody),
      ),
    );

    ApiClient.validateSuccess(response, [201]);

    return Mission.fromJson(json.decode(response.body));
  }

  /// PUT /missions/{id}/{status}?explanation=
  Future<Mission> updateMissionStatus({
    required String missionId,
    required MissionStatus status,
    String? explanation,
  }) async {
    final queryParams = <String, String>{};
    if (explanation != null) {
      queryParams['explanation'] = explanation;
    }

    final uri = Uri.parse(
      '$baseUrl/missions/$missionId/${status.name}',
    ).replace(queryParameters: queryParams);

    final response = await ApiClient.safeRequest(
      () => http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    ApiClient.validateSuccess(response, [200]);

    return Mission.fromJson(json.decode(response.body));
  }

  /// DELETE /missions/{id}
  Future<void> deleteMission(String missionId) async {
    final response = await ApiClient.safeRequest(
      () => http.delete(
        Uri.parse('$baseUrl/missions/$missionId'),
      ),
    );

    ApiClient.validateSuccess(response, [204]);
  }
}

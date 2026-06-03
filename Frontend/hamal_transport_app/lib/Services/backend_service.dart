import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/mission.dart';
import 'api_client.dart';
import 'authentication_service.dart';

class BackendService {
  // Change here!
  static const String _baseURL = '';
  final AuthenticationService _authService;

  BackendService({AuthenticationService? authService})
    : _authService = authService ?? AuthenticationService();

  String get _baseUrl => _baseURL;

  bool isEnabled() => _baseURL.isNotEmpty;

  Future<Map<String, String>> get _headers async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    try {
      final User? user = _authService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      final idToken = await user.getIdToken();
      if (idToken != null) {
        headers['Firebase-JWT'] = idToken;
      }
    } catch (e) {
      print('Failed to resolve security tokens: $e');
    }
    return headers;
  }

  // GET missions.
  Future<List<Mission>> getMissions(
    MissionStatus? status,
    String? driverId,
  ) async {
    final Map<String, String> queryParameters = {};
    if (status != null) {
      queryParameters['status'] = status.name;
    }
    if (driverId != null) {
      queryParameters['driver_id'] = driverId;
    }
    final Uri url = Uri.parse(
      '$_baseUrl/missions/',
    ).replace(queryParameters: queryParameters);
    final Map<String, String> headers = await _headers;
    final response = await APIClient.safeRequest(
      () => http.get(url, headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Mission.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load missions: ${response.statusCode}');
    }
  }

  // POST mission. Admin/Logistics only.
  Future<Mission> postMission(Mission mission) async {
    final Map<String, String> headers = await _headers;
    final Uri url = Uri.parse('$_baseUrl/missions/');
    final response = await APIClient.safeRequest(
      () =>
          http.post(url, headers: headers, body: json.encode(mission.toJson())),
    );
    if (response.statusCode == 201) {
      return Mission.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create mission: ${response.statusCode}');
    }
  }

  // UPDATE mission status.
  Future<Mission> updateMissionStatus(
    String missionId,
    MissionStatus newStatus,
  ) async {
    final Map<String, String> headers = await _headers;
    final Uri url = Uri.parse('$_baseUrl/missions/$missionId/update-status');
    final body = json.encode({'status': newStatus.name});
    final response = await APIClient.safeRequest(
      () => http.put(url, headers: headers, body: body),
    );
    if (response.statusCode == 200) {
      return Mission.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update status: ${response.statusCode}');
    }
  }

  Future<Mission> claimMission(String missionId) async {
    final Map<String, String> headers = await _headers;
    final Uri url = Uri.parse('$_baseUrl/missions/$missionId/claim');
    final response = await APIClient.safeRequest(
      () => http.post(url, headers: headers),
    );
    if (response.statusCode == 200) {
      return Mission.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to claim mission: ${response.statusCode}');
    }
  }

  Future<Mission> assignMission(String missionId, String driverUid) async {
    final Map<String, String> headers = await _headers;
    final Uri url = Uri.parse('$_baseUrl/missions/$missionId/assign');
    final body = json.encode({'driverUid': driverUid});
    final response = await APIClient.safeRequest(
      () => http.post(url, headers: headers, body: body),
    );
    if (response.statusCode == 200) {
      return Mission.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to assign mission: ${response.statusCode}');
    }
  }

  Future<Mission> cancelMission(String missionId, String reason) async {
    final Map<String, String> headers = await _headers;
    final Uri url = Uri.parse('$_baseUrl/missions/$missionId/cancel');
    final body = json.encode({
      'status': MissionStatus.cancelled.name,
      'cancellationReason': reason,
    });
    final response = await APIClient.safeRequest(
      () => http.post(url, headers: headers, body: body),
    );
    if (response.statusCode == 200) {
      return Mission.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to cancel mission: ${response.statusCode}');
    }
  }

  Future<Mission> abandonMission(String missionId) async {
    final Map<String, String> headers = await _headers;
    final Uri url = Uri.parse('$_baseUrl/missions/$missionId/abandon');
    final response = await APIClient.safeRequest(
      () => http.post(url, headers: headers),
    );
    if (response.statusCode == 200) {
      return Mission.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to abandon mission: ${response.statusCode}');
    }
  }

  Future<void> archiveMission(String missionId) async {
    final Map<String, String> headers = await _headers;
    final Uri url = Uri.parse('$_baseUrl/missions/$missionId/archive');
    final response = await APIClient.safeRequest(
      () => http.post(url, headers: headers),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to archive mission: ${response.statusCode}');
    }
  }

  // delete mission
  Future<void> deleteMission(String missionId) async {
    final Map<String, String> headers = await _headers;
    final Uri url = Uri.parse('$_baseUrl/missions/$missionId');
    final response = await APIClient.safeRequest(
      () => http.delete(url, headers: headers),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete mission: ${response.statusCode}');
    }
  }
}

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
      queryParameters['status'] = status.toString();
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

  // POST mission. Admin only?
  // Future<Mission> postMission(Mission mission) async {
  //   // TODO: complete function lol
  // }
  //
  // // UPDATE mission status.
  // Future<Mission> updateMissionStatus(String missionId, MissionStatus newStatus) async {
  //   // TODO: complete function lol
  // }
  //
  // // cancel mission
  // Future<Mission> deleteMission(String missionId){
  //   //TODO: complete function lol
  // }
}

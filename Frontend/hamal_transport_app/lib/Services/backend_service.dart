import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/mission.dart';
import 'api_client.dart';
import 'authentication_service.dart';

class MissionService{

  static const String _baseURL = 'http://192.168.1.194:8000';
  final AuthenticationService _authService;
  final APIClient _apiClient;

  MissionService._internal({AuthenticationService? authService, APIClient? apiClient})
      : _authService = authService ?? AuthenticationService(),
        _apiClient = apiClient ?? APIClient();

  static final MissionService _instance = MissionService._internal();
  factory MissionService() {
    return _instance;
  }

  String get _baseUrl => _baseURL;

  Future<Map<String, String>> get _headers async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    try{
      final User? user = _authService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      final idToken = await user.getIdToken(); //probably should move this to authentication service
      final appCheckToken = await _authService.getAppCheckToken();
      if (idToken != null) {
        headers['Firebase-JWT'] = idToken;
      }
      if (appCheckToken != null) {
        headers['Firebase-AppCheck'] = appCheckToken;
      }
    } catch(e){
      print('Failed to resolve security tokens: $e');
    }
    return headers;
  }

  // GET missions.
  Future<List<Mission>> getMissions(MissionStatus? status, String? driverId) async {

    final Map<String,String> queryParameters ={};
    if (status!=null){
      queryParameters['status']=status.toString();
    }
    if (driverId!=null){
      queryParameters['driver_id']=driverId;
    }
    final Uri url = Uri.parse('$_baseUrl/api/missions/').replace(queryParameters: queryParameters);
    final Map<String, String> headers = await _headers;
    final response = await APIClient.safeRequest(() => http.get(url, headers: headers));
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
  // Future<Mission> deleteMission(String missionId){
  //   //TODO: complete function lol
  // }


}
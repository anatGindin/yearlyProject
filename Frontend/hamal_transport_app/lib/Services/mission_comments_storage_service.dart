import 'package:hamal_transport_app/Models/mission.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MissionCommentsStorage {
  static String _keyFor(String missionId) => 'mission_comments_$missionId';

  /// Read all comments for a specific mission
  static Future<List<String>> readComments(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFor(missionId)) ?? [];
  }

  /// Overwrite all comments for a specific mission
  static Future<void> writeComments(
    String missionId,
    List<String> comments,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFor(missionId), comments);
  }

  /// Load comments directly into a Mission object
  static Future<void> loadCommentsIntoMission(Mission mission) async {
    mission.comments = await readComments(mission.id);
  }

  /// Save comments from a Mission object
  static Future<void> saveCommentsFromMission(Mission mission) async {
    await writeComments(mission.id, mission.comments);
  }

  /// Clear all comments for a specific mission
  static Future<void> clearComments(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFor(missionId));
  }
}

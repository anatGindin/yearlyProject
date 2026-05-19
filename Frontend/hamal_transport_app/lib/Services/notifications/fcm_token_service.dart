import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FcmTokenService {
  static Future<void> saveForCurrentUser(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final userTokenRef = FirebaseDatabase.instance.ref(
      'users/${user.uid}/fcmToken',
    );

    // TODO: Consider move this logic to a secure server-side function
    await userTokenRef.set(token);
    await FirebaseDatabase.instance
        .ref('users/${user.uid}/fcmTokenUpdatedAt')
        .set(ServerValue.timestamp);
  }
}

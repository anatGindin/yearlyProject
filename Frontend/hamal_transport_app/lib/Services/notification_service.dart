import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hamal_transport_app/firebase_options.dart';
import 'package:hamal_transport_app/Services/notifications/fcm_token_service.dart';
import 'package:hamal_transport_app/Services/notifications/notification_presenter.dart';

class FcmService {
  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final messaging = FirebaseMessaging.instance;

    await LocalNotificationService.initialize();

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('FCM permission status: ${settings.authorizationStatus}');

    final token = await _tryGetToken(messaging);
    debugPrint('FCM token: $token');

    if (token != null) {
      await FcmTokenService.saveForCurrentUser(token);
    }

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        return;
      }
      final refreshedToken = await _tryGetToken(messaging);
      if (refreshedToken != null) {
        await FcmTokenService.saveForCurrentUser(refreshedToken);
      }
    });

    messaging.onTokenRefresh.listen((String refreshedToken) async {
      debugPrint('FCM token refreshed: $refreshedToken');
      await FcmTokenService.saveForCurrentUser(refreshedToken);
    });

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.showFromMessage(message);
    });
  }

  static Future<void> handleUserSignOut(String uid) async {
    await FcmTokenService.clearForUser(uid);
    await _tryDeleteToken(FirebaseMessaging.instance);
  }

  static Future<String?> _tryGetToken(FirebaseMessaging messaging) async {
    try {
      return await messaging.getToken();
    } on FirebaseException catch (error) {
      debugPrint('FCM getToken failed: ${error.code} ${error.message}');
      return null;
    } catch (error) {
      debugPrint('FCM getToken failed: $error');
      return null;
    }
  }

  static Future<void> _tryDeleteToken(FirebaseMessaging messaging) async {
    try {
      await messaging.deleteToken();
    } on FirebaseException catch (error) {
      debugPrint('FCM deleteToken failed: ${error.code} ${error.message}');
    } catch (error) {
      debugPrint('FCM deleteToken failed: $error');
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (message.notification == null) {
    final backgroundPlugin =
        await LocalNotificationService.createBackgroundPlugin();
    await LocalNotificationService.showFromMessage(
      message,
      target: backgroundPlugin,
    );
  }
}

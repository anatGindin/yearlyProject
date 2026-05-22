import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel fcmChannel = AndroidNotificationChannel(
  'basic_fcm_channel',
  'Basic FCM Notifications',
  description: 'Channel for basic Firebase Cloud Messaging test notifications.',
  importance: Importance.high,
);

class NotificationPresenter {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    await _initializePlugin(plugin);
    _isInitialized = true;
  }

  static Future<void> showFromMessage(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    await plugin.show(
      message.messageId.hashCode,
      title ?? 'New notification',
      body ?? '',
      NotificationDetails(
        android: _isAndroid
            ? AndroidNotificationDetails(
                fcmChannel.id,
                fcmChannel.name,
                channelDescription: fcmChannel.description,
                importance: Importance.high,
                priority: Priority.high,
              )
            : null,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  static Future<void> _initializePlugin(
    FlutterLocalNotificationsPlugin target,
  ) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await target.initialize(settings);
    if (_isAndroid) {
      await target
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(fcmChannel);
    }
  }
}

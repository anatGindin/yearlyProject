import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel fcmChannel = AndroidNotificationChannel(
  'basic_fcm_channel',
  'Basic FCM Notifications',
  description: 'Channel for basic Firebase Cloud Messaging test notifications.',
  importance: Importance.high,
);

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _initializePlugin(plugin);
  }

  static Future<FlutterLocalNotificationsPlugin>
  createBackgroundPlugin() async {
    final backgroundPlugin = FlutterLocalNotificationsPlugin();
    await _initializePlugin(backgroundPlugin);
    return backgroundPlugin;
  }

  static Future<void> showFromMessage(
    RemoteMessage message, {
    FlutterLocalNotificationsPlugin? target,
  }) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    final targetPlugin = target ?? plugin;

    await targetPlugin.show(
      message.messageId.hashCode,
      title ?? 'New notification',
      body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          fcmChannel.id,
          fcmChannel.name,
          channelDescription: fcmChannel.description,
          importance: Importance.high,
          priority: Priority.high,
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
    const settings = InitializationSettings(android: androidSettings);

    await target.initialize(settings);
    await target
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(fcmChannel);
  }
}

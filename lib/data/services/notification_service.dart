import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late final AndroidNotificationChannel channel;

  Future<void> initialize() async {
    
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print("Permisos de notificación: ${settings.authorizationStatus}");

 
    String? token = await _firebaseMessaging.getToken();
    print("Token FCM: $token");


    channel = const AndroidNotificationChannel(
      'recycle_reminder_channel',
      'Recycle Reminders',
      description: 'Notifications to remind about recycling',
      importance: Importance.high,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      print("Notificación pulsada: ${details.payload}");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
      );
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Mensaje en background recibido: ${message.notification?.title}");
  }

  Future<void> showNotification(String title, String body) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotificationsPlugin.show(0, title, body, notificationDetails);
    print("Notificación mostrada: $title - $body");
  }
}

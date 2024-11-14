import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late final AndroidNotificationChannel channel;

  Future<void> initialize() async {
    // Solicita permisos de notificaciones
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print("Permisos de notificación: ${settings.authorizationStatus}");

    // Obtén y muestra el token FCM
    String? token = await _firebaseMessaging.getToken();
    print("Token FCM: $token");

    // Configura el canal de notificaciones para Android
    channel = const AndroidNotificationChannel(
      'recycle_reminder_channel',
      'Recycle Reminders',
      description: 'Notifications to remind about recycling',
      importance: Importance.high,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Inicialización para Android e iOS
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
      // Navega o ejecuta lógica si es necesario
    });

    // Escucha notificaciones en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Mensaje recibido en foreground: ${message.notification?.title}");
      showNotification(
        message.notification?.title ?? 'Sin título',
        message.notification?.body ?? 'Sin contenido',
      );
    });

    // Maneja mensajes en background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Maneja mensajes cuando se hace clic desde la bandeja
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notificación abierta: ${message.notification?.title}");
      // Navega a una pantalla específica si es necesario
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Mensaje recibido en background: ${message.notification?.title}");
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

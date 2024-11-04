import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String defaultChannelId = 'recycle_reminder_channel';

  Future<void> initialize() async {
    
    await _firebaseMessaging.requestPermission();
    print("Notification permissions requested.");

    
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      defaultChannelId, 
      'Recycle Reminders', 
      description: 'Notifications to remind about recycling',
      importance: Importance.high,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    print("Notification channel created.");

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(initializationSettings);
    print("Local notifications plugin initialized.");

    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
      );
    });
    print("Foreground message listener set up.");
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      defaultChannelId, 
      'Recycle Reminders', 
      channelDescription: 'Notifications to remind about recycling',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.show(
      0, 
      title,
      body,
      platformChannelSpecifics,
    );
    print("Notification shown with title: $title and body: $body");
  }

  Future<void> scheduleDailyRecycleReminder() async {
    await _localNotificationsPlugin.zonedSchedule(
      1,
      'Time to Recycle!',
      'Don’t forget to recycle today.',
      _nextInstanceOfTime(10, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          defaultChannelId,
          'Daily Recycle Reminder',
          channelDescription: 'Daily reminder to recycle',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    print("Daily recycle reminder scheduled.");
  }

  Future<void> scheduleEndOfDayReminder() async {
    await _localNotificationsPlugin.zonedSchedule(
      2,
      'End of Day Reminder',
      'Don’t lose your recycling streak!',
      _nextInstanceOfTime(20, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          defaultChannelId,
          'End of Day Reminder',
          channelDescription: 'Reminder at the end of the day',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    print("End of day reminder scheduled.");
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

import 'package:flutter/material.dart';
import 'package:sustain_u/core/utils/sustainu_colors.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sustain_u/data/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Mensaje en background: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(camera: firstCamera, navigatorObservers: [routeObserver]));
}

class MyApp extends StatefulWidget {
  final CameraDescription camera;
  final List<NavigatorObserver> navigatorObservers;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  const MyApp({required this.camera, required this.navigatorObservers});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializeNotificationService();
  }

  Future<void> _initializeNotificationService() async {
    await _notificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [MyApp.observer],
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: SustainUColors.text,
          ),
        ),
      ),
      initialRoute: '/',
      routes: AppRoutes.routes(widget.camera),
    );
  }
}

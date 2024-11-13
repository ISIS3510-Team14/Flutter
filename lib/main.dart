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

// Constante del esquema de tu app
const appScheme = 'flutter.sustainu';

// Método para manejar mensajes en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Inicializa Firebase si aún no está inicializado
  await Firebase.initializeApp();
  print("Handling a background message: ${message.notification?.title}");
  // Opcional: Realiza acciones silenciosas aquí (e.g., actualizar base de datos)
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtén la cámara disponible
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configura el manejador de mensajes en segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatefulWidget {
  final CameraDescription camera;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  const MyApp({required this.camera});

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

  // Inicializa el servicio de notificaciones
  Future<void> _initializeNotificationService() async {
    await _notificationService.initialize();

    // Obtén y registra el token FCM
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
      // Puedes enviar este token a tu backend si es necesario.
    });

    // Maneja notificaciones cuando la app está abierta (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
      if (message.notification != null) {
        _notificationService.showNotification(
          message.notification?.title ?? "No Title",
          message.notification?.body ?? "No Body",
        );
      }
    });

    // Maneja notificaciones cuando se hace clic en ellas desde la bandeja
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.notification?.title}");
      // Puedes agregar lógica para navegar a una pantalla específica
    });
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
          displayMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: SustainUColors.text,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
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

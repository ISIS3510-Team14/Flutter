import 'package:flutter/material.dart';
import 'routes/app_routes.dart';  // Import your AppRoutes
import 'constants/app_constants.dart';  // Any constants you might be using

import 'package:camera/camera.dart';  // Import the camera package

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({required this.camera});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',  // Initial route set to splash screen
      routes: AppRoutes.routes(camera),  // Use the routes from AppRoutes class
    );
  }
}

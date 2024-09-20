import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'routes/app_routes.dart';
import 'constants/app_constants.dart';

void main() {
  runApp(SustainUApp());
}

class SustainUApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}

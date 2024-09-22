import 'package:flutter/material.dart';
import 'routes/app_routes.dart';  // Import your AppRoutes
import 'constants/app_constants.dart';  // Any constants you might be using

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      routes: AppRoutes.routes,  // Use the routes from AppRoutes class
    );
  }
}

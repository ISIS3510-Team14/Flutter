import 'package:flutter/material.dart';
import 'package:sustain_u/utils/sustanu_colors.dart';
import 'routes/app_routes.dart';  
import 'constants/app_constants.dart';  
import 'package:auth0_flutter/auth0_flutter.dart';

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
      initialRoute: '/',  // Initial route set to splash screen
      routes: AppRoutes.routes,  // Use the routes from AppRoutes class
    );
  }
}

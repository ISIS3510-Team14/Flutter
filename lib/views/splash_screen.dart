import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/sustanu_colors.dart';
import 'login_screen.dart';
import '../constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(AppConstants.splashDelay, () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 120), // Replace with your logo path
            SizedBox(height: 20),
            Text(AppConstants.appName, style: TextStyle(fontSize: 32, color: SustainUColors.limeGreen)),
          ],
        ),
      ),
    );
  }
}

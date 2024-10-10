import 'package:flutter/material.dart';
import 'package:sustain_u/views/home_screen.dart';
import 'package:sustain_u/views/profile_screen.dart';
import '../views/splash_screen.dart';
import '../views/sign_in_screen.dart';
import '../views/verification_screen.dart';
import '../views/home_screen.dart';
import '../views/profile_screen.dart';
import '../views/camera_screen.dart';
import 'package:camera/camera.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes(CameraDescription camera){
    return {
    '/': (context) => SplashScreen(),
    '/sign_in': (context) => SignInScreen(),
    '/verification': (context) => VerificationScreen(),
    '/home': (context) => HomeScreen(),
    '/profile': (context) => ProfileScreen(),
    '/camera': (context) => CameraScreen(camera: camera),
    };
  }
}

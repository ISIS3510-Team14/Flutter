import 'package:flutter/material.dart';
import 'package:sustain_u/presentation/views/home_screen.dart';
import 'package:sustain_u/presentation/views/map.dart';
import 'package:sustain_u/presentation/views/profile_screen.dart';
import '../../presentation/views/login_screen.dart';
import '../../presentation/views/sign_in_screen.dart';
import '../../presentation/views/verification_screen.dart';
import '../../presentation/views/camera_screen.dart';
import 'package:camera/camera.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes(CameraDescription camera){
    return {
    '/': (context) => LoginScreen(),
    '/sign_in': (context) => SignInScreen(),
    '/verification': (context) => VerificationScreen(),
    '/home': (context) => HomeScreen(),
    '/profile': (context) => ProfileScreen(),
    '/camera': (context) => CameraScreen(camera: camera),
    '/map': (context) => GoogleMaps(),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:sustain_u/views/home_screen.dart';
import 'package:sustain_u/views/profile_screen.dart';
import '../views/splash_screen.dart';
import '../views/sign_in_screen.dart';
import '../views/sign_up_screen.dart';
import '../views/forgot_password_screen.dart';
import '../views/verification_screen.dart';
import '../views/new_password_screen.dart';
import '../views/confirmation_screen.dart';
import '../views/sign_up2_screen.dart';
import '../views/home_screen.dart';
import '../views/profile_screen.dart';
import '../views/camera_screen.dart';
import 'package:camera/camera.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes(CameraDescription camera){
    return {
    '/': (context) => SplashScreen(),
    '/sign_in': (context) => SignInScreen(),
    '/sign_up': (context) => SignUpScreen(),
    '/sign_up2': (context) => SignUp2Screen(),
    '/forgot_password': (context) => ForgotPasswordScreen(),
    '/verification': (context) => VerificationScreen(),
    '/new_password': (context) => NewPasswordScreen(),
    '/confirmation': (context) => ConfirmationScreen(),
    '/home': (context) => HomeScreen(),
    '/profile': (context) => ProfileScreen(),
    '/camera': (context) => CameraScreen(camera: camera),
    };
  }
}

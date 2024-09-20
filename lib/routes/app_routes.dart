import 'package:flutter/material.dart';
import '../views/splash_screen.dart';
import '../views/login_screen.dart';
import '../views/sign_in_screen.dart';
import '../views/sign_up_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => SplashScreen(),
    '/login': (context) => LoginScreen(),
    '/sign_in': (context) => SignInScreen(),
    '/sign_up': (context) => SignUpScreen(),
  };
}

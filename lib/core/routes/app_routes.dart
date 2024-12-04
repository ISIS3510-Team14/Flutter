import 'package:flutter/material.dart';
import 'package:sustain_u/presentation/views/history_screen.dart';
import 'package:sustain_u/presentation/views/home_screen.dart';
import 'package:sustain_u/presentation/views/map.dart';
import 'package:sustain_u/presentation/views/profile_screen.dart';
import 'package:sustain_u/presentation/views/recycle/metal_screen.dart';
import 'package:sustain_u/presentation/views/recycle/glass_screen.dart';
import 'package:sustain_u/presentation/views/recycle/organic_screen.dart';
import 'package:sustain_u/presentation/views/recycle/other_screen.dart';
import 'package:sustain_u/presentation/views/recycle/paper_screen.dart';
import 'package:sustain_u/presentation/views/recycle/plastic_screen.dart';
import 'package:sustain_u/presentation/views/recycle_screen.dart';
import 'package:sustain_u/presentation/views/scoreboard_screen.dart';
import '../../presentation/views/login_screen.dart';
import '../../presentation/views/sign_in_screen.dart';
import '../../presentation/views/camera_screen.dart';
import '../../presentation/views/view_images_screen.dart';
import 'package:camera/camera.dart';
import 'package:sustain_u/presentation/views/instructions_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes(CameraDescription camera) {
    return {
      '/': (context) => LoginScreen(),
      '/sign_in': (context) => SignInScreen(),
      '/home': (context) => HomeScreen(),
      '/profile': (context) => ProfileScreen(),
      '/camera': (context) => CameraScreen(camera: camera),
      '/map': (context) => GoogleMaps(),
      '/recycle': (context) => RecycleScreen(),
      '/scoreboard': (context) => ScoreboardScreen(),
      '/history': (context) => HistoryScreen(),
      '/instructions': (context) => InstructionsScreen(),
      '/paper': (context) => PaperScreen(),
      '/plastic': (context) => PlasticScreen(),
      '/metal': (context) => MetalScreen(),
      '/glass': (context) => GlassScreen(),
      '/viewImages': (context) {
        // Extrae el email del usuario desde argumentos o almacenamiento
        final userEmail = ModalRoute.of(context)?.settings.arguments as String? ?? '';
        return ViewImagesScreen(userEmail: userEmail);
      },
      '/others': (context) => OtherScreen(),
      '/organic': (context) => OrganicScreen(),
    };
  }
}


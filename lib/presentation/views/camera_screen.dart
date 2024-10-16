import 'package:flutter/material.dart';
import 'package:sustain_u/presentation/widgets/bottom_navbar.dart';
import '../widgets/camera_widget.dart';
import 'package:camera/camera.dart';
import '../widgets/head.dart';

class CameraScreen extends StatelessWidget {
  final CameraDescription camera;

  const CameraScreen({required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 16.0, right: 16.0),
            child: HeaderWidget(),
          ),
          Expanded(
            child: CameraWidget(camera: camera),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}

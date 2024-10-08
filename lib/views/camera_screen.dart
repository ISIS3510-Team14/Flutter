import 'package:flutter/material.dart';
import '../widgets/camera_widget.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatelessWidget {
  final CameraDescription camera;

  const CameraScreen({required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture')),
      body: Column(
        children: [
          Expanded(
            child: CameraWidget(camera: camera),
          ),
          // Aquí puedes añadir más widgets para la vista más grande
        ],
      ),
    );
  }
}
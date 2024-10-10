import 'package:flutter/material.dart';
import 'package:sustain_u/widgets/bottom_navbar.dart';
import '../widgets/camera_widget.dart';
import 'package:camera/camera.dart';
import '../widgets/head.dart';


class CameraScreen extends StatelessWidget {
  final CameraDescription camera;

  const CameraScreen({required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Take a Picture')),
      body: Column(
        children: [
          SizedBox(height: 20),
          HeaderWidget(),
          Expanded(
            child: CameraWidget(camera: camera),
            
          ),
          
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
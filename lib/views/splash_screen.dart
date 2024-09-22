import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cargar la imagen principal
            Image.asset('assets/img.png'),  // Asegúrate de que esta ruta coincida con la estructura de tu proyecto
            SizedBox(height: 20),
            // Cargar el logo
            Image.asset('assets/logo.png'), // Asegúrate de que esta ruta coincida con la estructura de tu proyecto
            SizedBox(height: 20),
            Text(
              'SustainU',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_in');
              },
              child: Text('Sign In'),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB1CC33)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_up');
              },
              child: Text('Sign Up', style: TextStyle(color: Color(0xFFB1CC33))),
            ),
          ],
        ),
      ),
    );
  }
}

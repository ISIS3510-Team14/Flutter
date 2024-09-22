import 'package:flutter/material.dart';
import '../utils/sustainu_colors.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cargar la imagen principal
            Image.network(
              'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/img.png',
              height: 180, 
              width: 180,  
            ),  
            SizedBox(height: 10),
            // Cargar el logo
            Image.network('https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logo.png',
            height: 130, 
              width: 130, 
              ), 
            SizedBox(height: 5, width: 5),
            Text(
              'SustainU',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_in');
              },
              child: Text('Sign In', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB1CC33), minimumSize: Size(200, 50)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_up');
              },
              child: Text('Sign Up', style: TextStyle(color: Color(0xFFB1CC33))),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(color: Color(0xFFB1CC33), width: 2), minimumSize: Size(200, 50)),
            ),
          ],
        ),
      ),
    );
  }
}

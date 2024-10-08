import 'package:flutter/material.dart';
import '../utils/sustanu_colors.dart';

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      body: Center(  // Centra todo el contenido
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centra verticalmente
            crossAxisAlignment: CrossAxisAlignment.center,  // Centra horizontalmente
            children: [
              Icon(Icons.check_circle, size: 100, color: SustainUColors.limeGreen),
              SizedBox(height: 20),
              Text(
                'All right!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: SustainUColors.text,
                ),
                textAlign: TextAlign.center,  // Asegura que el texto también esté centrado
              ),
              SizedBox(height: 10),
              Text(
                'The password was successfully changed',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: SustainUColors.textLight,
                ),
                textAlign: TextAlign.center,  // Centra el texto
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sign_in');
                },
                child: Text(
                  'Log in',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SustainUColors.limeGreen,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),  // Esquinas redondeadas para el botón
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../utils/sustainu_colors.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 120), // Logo path
            SizedBox(height: 20),
            Text('SustainU', style: TextStyle(fontSize: 32, color: SustainUColors.limeGreen)),
            SizedBox(height: 40),
            CustomButton(
              text: 'Sign In',
              color: SustainUColors.limeGreen,
              onPressed: () {
                Navigator.of(context).pushNamed('/sign_in');
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Sign Up',
              color: SustainUColors.lightBlue,
              onPressed: () {
                Navigator.of(context).pushNamed('/sign_up');
              },
            ),
          ],
        ),
      ),
    );
  }
}

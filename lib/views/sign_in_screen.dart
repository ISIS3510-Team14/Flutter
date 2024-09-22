import 'package:flutter/material.dart';
import '../utils/sustainu_colors.dart';
import '../widgets/custom_button.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back Button (from screenshot)
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: SustainUColors.limeGreen),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(height: 20),
            // Welcome Text
            Text('Welcome!', style: TextStyle(fontSize: 32, color: SustainUColors.limeGreen)),
            SizedBox(height: 30),
            // Phone Number Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone number',
                labelStyle: TextStyle(color: SustainUColors.limeGreen),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Zip Code Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Zip code',
                labelStyle: TextStyle(color: SustainUColors.limeGreen),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Accept Notifications Checkbox (if needed)
            Row(
              children: [
                Checkbox(value: true, onChanged: (bool? value) {}),
                Text("Accept getting notifications from the app")
              ],
            ),
            SizedBox(height: 30),
            // Sign In Button
            CustomButton(
              text: 'Sign In',

              color: SustainUColors.limeGreen,
              onPressed: () {
                // Handle sign-in logic
                Navigator.pushNamed(context, '/camera');
              },
            ),
          ],
        ),
      ),
    );
  }
}

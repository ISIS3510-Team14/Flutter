import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';  // Make sure Auth0 is imported
import '../utils/sustainu_colors.dart';

class ProfileScreen extends StatelessWidget {
  final Auth0 auth0 = Auth0( // Ensure Auth0 instance is available in the profile screen
    'dev-0jbbiqg2ogpddh7c.us.auth0.com',
    'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p',
  );

  // Logout action to clear session and redirect to splash screen
  Future<void> logoutAction(BuildContext context) async {
    try {
      await auth0.webAuthentication(scheme: 'flutter.SustainU').logout();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print('Logout failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SustainUColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: SustainUColors.limeGreen),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: SustainUColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lucía Joven',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: SustainUColors.text,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: SustainUColors.text),
              title: Text('Logout', style: TextStyle(color: SustainUColors.text)),
              onTap: () {
                logoutAction(context); // Call the logout action when tapping on logout
              },
            ),
          ],
        ),
      ),
    );
  }
}

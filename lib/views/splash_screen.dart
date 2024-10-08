import 'package:flutter/material.dart';
import '../utils/sustainu_colors.dart';
import 'package:auth0_flutter/auth0_flutter.dart';

class SplashScreen extends StatelessWidget {
  final auth0 = Auth0(
    'dev-0jbbiqg2ogpddh7c.us.auth0.com',  // Auth0 domain
    'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p',  // Auth0 client ID
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Load the main image
            Image.network(
              'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/img.png',
              height: 180,
              width: 180,
            ),
            SizedBox(height: 10),
            // Load the logo
            Image.network(
              'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logo.png',
              height: 130,
              width: 130,
            ),
            SizedBox(height: 5),
            Text(
              'SustainU',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Trigger the Auth0 Universal Login for Sign In
                  final result = await auth0.webAuthentication().login(
                    redirectUrl: 'flutter.SustainU://dev-0jbbiqg2ogpddh7c.us.auth0.com/android/com.sustainu.app/callback',
                  );

                  print('Logged in: ${result.accessToken}');
                  print('User name: ${result.user.name}');

                  // Navigate to the app's main content and pass the user's name
                  Navigator.pushNamed(
                    context,
                    '/home',
                    arguments: {'name': result.user.name},  // Pass the user's name
                  );
                } catch (e) {
                  print('Login failed: $e');
                }
              },
              child: Text('Sign In', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB1CC33),
                minimumSize: Size(200, 50),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                try {
                  // Trigger the Auth0 Universal Login for Sign Up with screen_hint 'signup'
                  final result = await auth0.webAuthentication().login(
                    redirectUrl: 'flutter.SustainU://dev-0jbbiqg2ogpddh7c.us.auth0.com/android/com.sustainu.app/callback',
                    parameters: {
                      'screen_hint': 'signup',  // Tell Auth0 to show the Sign Up screen
                    },
                  );

                  print('Signed Up: ${result.accessToken}');
                  print('User name: ${result.user.name}');

                  // Navigate to the app's main content and pass the user's name
                  Navigator.pushNamed(
                    context,
                    '/home',
                    arguments: {'name': result.user.name},  // Pass the user's name
                  );
                } catch (e) {
                  print('Sign Up failed: $e');
                }
              },
              child: Text('Sign Up', style: TextStyle(color: Color(0xFFB1CC33))),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Color(0xFFB1CC33), width: 2),
                minimumSize: Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

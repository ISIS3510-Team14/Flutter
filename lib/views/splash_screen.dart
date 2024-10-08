import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import '../utils/sustainu_colors.dart'; // Assuming custom colors

const appScheme = 'flutter.SustainU';  // Ensure this matches your app scheme

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = false;  // Flag for showing loading indicator
  String _errorMessage = '';  // Display error messages
  Credentials? _credentials;  // Hold credentials after login
  late Auth0 auth0;  // Initialize Auth0

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-0jbbiqg2ogpddh7c.us.auth0.com', 'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p');
  }

  // Login/Sign up action (combined for simplicity)
  Future<void> authenticate() async {
    setState(() {
      _isLoading = true;  // Show loading indicator
      _errorMessage = '';  // Clear error message
    });

    try {
      // Trigger the Universal Login
      final credentials = await auth0.webAuthentication(
        scheme: appScheme,
      ).login();

      setState(() {
        _isLoading = false;
        _credentials = credentials;
      });

      // Navigate to the home screen, passing user info
      Navigator.pushNamed(
        context,
        '/home',
        arguments: {'name': credentials.user.name},  // Pass user name to the home screen
      );
    } catch (e) {
      // Handle login error
      setState(() {
        _isLoading = false;
        _errorMessage = 'Login failed: ${e.toString()}';
      });
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()  // Show a loading indicator if login is in progress
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the app logo
                  Image.network(
                    'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/img.png',
                    height: 180,
                    width: 180,
                  ),
                  SizedBox(height: 10),
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
                  // Login/Sign-up button combined
                  ElevatedButton(
                    onPressed: authenticate,  // Perform login or sign up
                    child: Text('Log in / Sign up', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB1CC33),
                      minimumSize: Size(220, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  // Display error message if login fails
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),  // Display error in red color
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

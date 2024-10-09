import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import '../utils/sustainu_colors.dart'; 

const appScheme = 'flutter.sustainu';  

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = false;  
  String _errorMessage = '';  
  Credentials? _credentials;  
  late Auth0 auth0;  

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-0jbbiqg2ogpddh7c.us.auth0.com', 'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p');
  }

  Future<void> authenticate() async {
    setState(() {
      _isLoading = true;  
      _errorMessage = '';  
    });

    try {
      final credentials = await auth0.webAuthentication(
        scheme: appScheme,
      ).login();

      setState(() {
        _isLoading = false;
        _credentials = credentials;
      });
      print('User token: ${credentials.accessToken}');
      
    
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,  
        arguments: {'name': credentials.user.name},  
      );
      
    } catch (e) {
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
            ? CircularProgressIndicator()  
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the app logo
                  Image.network(
                    'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/img.png',
                    height: 250,
                    width: 250,
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
                  
                  ElevatedButton(
                    onPressed: authenticate,  
                    child: Text('Log in / Sign up', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB1CC33),
                      minimumSize: Size(220, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  
                
                ],
              ),
      ),
    );
  }
}

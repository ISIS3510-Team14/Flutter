import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import '../utils/sustainu_colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  final auth0 = Auth0(
    'dev-0jbbiqg2ogpddh7c.us.auth0.com',  // Auth0 domain
    'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p',  // Auth0 client ID
  );

  bool _isLoading = false;
  bool _isLoginInProgress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _isLoginInProgress = false;
      });
    }
  }

  void _toggleLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> _handleLogin() async {
    if (_isLoginInProgress) return;

    _toggleLoading(true);
    _isLoginInProgress = true;

    try {
      // Timeout to prevent long delays
      final result = await auth0.webAuthentication().login(
        redirectUrl: 'flutter.SustainU://dev-0jbbiqg2ogpddh7c.us.auth0.com/android/com.sustainu.app/callback',
        // Ensure no custom login pages are being used and Universal Login is served by default
      ).timeout(Duration(seconds: 60), onTimeout: () {
        throw Exception('Login timeout. Please try again.');
      });

      print('Logged in: ${result.accessToken}');
      print('User name: ${result.user.name}');

      Navigator.pushNamed(
        context,
        '/home',
        arguments: {'name': result.user.name},  // Pass the user's name to home
      );
    } catch (e) {
      print('Login failed: $e');
    } finally {
      _toggleLoading(false);
      _isLoginInProgress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              CircularProgressIndicator(),
            if (!_isLoading) ...[
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
              ElevatedButton(
                onPressed: _handleLogin,
                child: Text('Login', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB1CC33),
                  minimumSize: Size(200, 50),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

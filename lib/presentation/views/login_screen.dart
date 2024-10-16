import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';  
import '../../core/utils/sustainu_colors.dart';
import '../../data/services/storage_service.dart';

const appScheme = 'flutter.sustainu';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _errorMessage = '';
  late Auth0 auth0;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    auth0 = Auth0(
      'dev-0jbbiqg2ogpddh7c.us.auth0.com',
      'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p',
    );
    _checkIfLoggedIn();
  }

  Future<void> _checkIfLoggedIn() async {
    Map<String, dynamic>? storedCredentials =
        await _storageService.getUserCredentials();
    if (storedCredentials != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  Future<void> authenticate() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final credentials = await auth0.webAuthentication(scheme: appScheme).login();

      // Decodificando el idToken para acceder a los claims
      Map<String, dynamic> decodedToken = JwtDecoder.decode(credentials.idToken);

      final lastLogin = credentials.user.updatedAt?.toIso8601String() ?? 'Unknown Date';
      final fullName = decodedToken['name'] ?? 'Unknown User';
      final nickname = decodedToken['nickname'] ?? 'Unknown';
      final pictureUrl = decodedToken['picture'] ?? '';  

      final userData = {
        'full_name': fullName,
        'nickname': nickname,
        'email': credentials.user.email ?? 'Unknown Email',
        'last_login': lastLogin,
        'picture': pictureUrl,  // Guardando la imagen
      };

      await _storageService.saveUserCredentials(userData);

      setState(() {
        _isLoading = false;
      });

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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

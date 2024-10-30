import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';  
import 'package:connectivity_plus/connectivity_plus.dart'; // New import for connectivity
import '../../core/utils/sustainu_colors.dart';
import '../../data/services/storage_service.dart';

const appScheme = 'flutter.sustainu';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isConnected = true; // To track internet connection status
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
    _checkInternetConnection(); // Check the connection on app start
  }

  Future<void> _checkIfLoggedIn() async {
    Map<String, dynamic>? storedCredentials =
        await _storageService.getUserCredentials();
    if (storedCredentials != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool connected = connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
    
    setState(() {
      _isConnected = connected;
    });
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
                  Image.asset(
                    'assets/img.png',
                    height: 250,
                    width: 250,
                  ),
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/logo.png',
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
                    onPressed: _isConnected ? authenticate : null,
                    child: Text('Log in / Sign up', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isConnected ? Color(0xFFB1CC33) : Colors.grey,
                      minimumSize: Size(220, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  if (!_isConnected) ...[
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _checkInternetConnection,
                      child: Text('Retry', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: Size(220, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No Internet Connection',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/instructions'
                      );
                    },
                    child: Text(
                      'Instructions',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: SustainUColors.text,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

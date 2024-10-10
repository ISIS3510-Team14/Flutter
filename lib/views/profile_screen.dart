import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import '../utils/sustainu_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';  // Importa la clase de almacenamiento

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Auth0 auth0 = Auth0('dev-0jbbiqg2ogpddh7c.us.auth0.com', 'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p');
  final StorageService _storageService = StorageService();  // Instancia de la clase StorageService
  String _userName = 'Unknown User';  // Default name
  String _userEmail = 'Unknown Email';  // Default email

  @override
  void initState() {
    super.initState();
    _loadUserProfile();  // Cargar el perfil del usuario
  }

  Future<void> _loadUserProfile() async {
    // Cargar el nombre y correo desde SharedPreferences
    String? storedUserName = await _storageService.getUserName();
    setState(() {
      _userName = storedUserName ?? 'Unknown User';
    });

    // Nota: Si también guardaste el correo en `SharedPreferences`, puedes cargarlo de la misma manera.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userEmail');  // Puedes guardar el email en el login
    setState(() {
      _userEmail = email ?? 'Unknown Email';
    });
  }

  Future<void> logoutAction(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();  // Limpiar todos los datos del usuario
      await auth0.webAuthentication(scheme: 'flutter.sustainu').logout();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);  // Navegar de vuelta al login
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
            SizedBox(height: 20),
            Text(
              _userName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: SustainUColors.text,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _userEmail,
              style: TextStyle(
                fontSize: 18,
                color: SustainUColors.text,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: SustainUColors.text),
              title: Text('Logout', style: TextStyle(color: SustainUColors.text)),
              onTap: () {
                logoutAction(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

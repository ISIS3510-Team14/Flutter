import 'package:flutter/material.dart';
import '../../core/utils/sustainu_colors.dart';
import '../../data/services/storage_service.dart';
import 'package:auth0_flutter/auth0_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  final Auth0 auth0 = Auth0(
    'dev-0jbbiqg2ogpddh7c.us.auth0.com',
    'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p',
  );

  String _nickname = 'Unknown User';
  String _email = 'Unknown Email';
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    Map<String, dynamic>? userProfile = await _storageService.getUserCredentials();

    setState(() {
      _nickname = userProfile?['nickname'] ?? 'Unknown User';
      _email = userProfile?['email'] ?? 'Unknown Email';
      _profilePicture = userProfile?['picture'];
    });
  }

  Future<void> logoutAction(BuildContext context) async {
    try {
      await _storageService.clearUserData();
      await auth0.webAuthentication(scheme: 'flutter.sustainu').logout();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print('Logout failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout. Please try again.')),
      );
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
      body: Center( // Centra todo el contenido
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Alinea todo en el centro verticalmente
            crossAxisAlignment: CrossAxisAlignment.center, // Alinea todo en el centro horizontalmente
            children: [
              // Perfil centrado
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                backgroundImage: _profilePicture != null && _profilePicture!.isNotEmpty
                    ? NetworkImage(_profilePicture!)
                    : null,
                child: _profilePicture == null || _profilePicture!.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      )
                    : null,
              ),
              SizedBox(height: 20),
              // Nombre en negrilla grande
              Text(
                'Nickname: $_nickname',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: SustainUColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              // Email más pequeño y no en negrilla
              Text(
                'Email: $_email',
                style: TextStyle(
                  fontSize: 16,
                  color: SustainUColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // Botón de Logout grande, redondo, con ícono
              ElevatedButton.icon(
                onPressed: () {
                  logoutAction(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SustainUColors.coralOrange, // Color coralOrange
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Botón redondeado
                  ),
                ),
                icon: Icon(Icons.exit_to_app, size: 28, color: Colors.white),
                label: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  String? _profilePicture; // Variable para almacenar la URL de la imagen

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
      _profilePicture = userProfile?['picture']; // Recupera la imagen guardada
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
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
            // Mostrar la imagen de perfil o un ícono por defecto si no está disponible
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              backgroundImage: _profilePicture != null && _profilePicture!.isNotEmpty
                  ? NetworkImage(_profilePicture!)
                  : null,
              child: _profilePicture == null || _profilePicture!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(height: 20),
            _buildInfoRow('Username', _nickname),
            _buildInfoRow('Email', _email),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: SustainUColors.text),
              title: Text(
                'Logout',
                style: TextStyle(color: SustainUColors.text),
              ),
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

import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import '../utils/sustainu_colors.dart';

class ProfileScreen extends StatelessWidget {
  final Auth0 auth0 = Auth0('dev-0jbbiqg2ogpddh7c.us.auth0.com', 'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p');

  Future<void> logoutAction(BuildContext context) async {
    try {
      await auth0.webAuthentication(scheme: 'flutter.sustainu').logout();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);  
    } catch (e) {
      print('Logout failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final credentials = ModalRoute.of(context)!.settings.arguments as Credentials?;
    final userName = credentials?.user.name ?? 'Unknown User';
    final userEmail = credentials?.user.email ?? 'Unknown Email';

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
            ListTile(
              leading: Icon(Icons.account_circle, color: SustainUColors.text),
              title: Text('Perfil', style: TextStyle(color: SustainUColors.text)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(),  
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              userName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: SustainUColors.text,
              ),
            ),
            SizedBox(height: 10),
            Text(
              userEmail,
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

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: SustainUColors.background,
      ),
      backgroundColor: SustainUColors.background,
      body: Center(
        child: Text('Aquí puedes editar tu perfil'),  
      ),
    );
  }
}

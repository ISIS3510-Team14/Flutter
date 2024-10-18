import 'package:flutter/material.dart';
import '../../core/utils/sustainu_colors.dart';
import '../../data/services/storage_service.dart';
import 'package:auth0_flutter/auth0_flutter.dart';


class UserProfile {
  final String nickname;
  final String email;
  final String? profilePicture;

  UserProfile({
    required this.nickname,
    required this.email,
    this.profilePicture,
  });
}

// ProfileFactory que crea el perfil
abstract class ProfileFactory {
  Future<UserProfile> createProfile();
}

// Implementación concreta de ProfileFactory para crear un perfil desde StorageService
class StorageProfileFactory implements ProfileFactory {
  final StorageService _storageService;

  StorageProfileFactory(this._storageService);

  @override
  Future<UserProfile> createProfile() async {
    Map<String, dynamic>? userProfile = await _storageService.getUserCredentials();

    return UserProfile(
      nickname: userProfile?['nickname'] ?? 'Unknown User',
      email: userProfile?['email'] ?? 'Unknown Email',
      profilePicture: userProfile?['picture'],
    );
  }
}

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

  late Future<UserProfile> _userProfile;

  @override
  void initState() {
    super.initState();
    // Utilizando la fábrica para cargar el perfil
    ProfileFactory profileFactory = StorageProfileFactory(_storageService);
    _userProfile = profileFactory.createProfile();
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
      body: FutureBuilder<UserProfile>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading profile'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No profile data'));
          }

          final userProfile = snapshot.data!;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue,
                    backgroundImage: userProfile.profilePicture != null && userProfile.profilePicture!.isNotEmpty
                        ? NetworkImage(userProfile.profilePicture!)
                        : null,
                    child: userProfile.profilePicture == null || userProfile.profilePicture!.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${userProfile.nickname}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: SustainUColors.text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: ${userProfile.email}',
                    style: TextStyle(
                      fontSize: 16,
                      color: SustainUColors.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () {
                      logoutAction(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SustainUColors.coralOrange,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
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
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/utils/sustainu_colors.dart';
import '../../data/services/storage_service.dart';

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
  bool _isConnected = true;
  final StorageService _storageService = StorageService();
  final Auth0 auth0 = Auth0(
    'dev-0jbbiqg2ogpddh7c.us.auth0.com',
    'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p',
  );

  late Future<UserProfile> _userProfile;
  late Connectivity _connectivity;

  @override
  void initState() {
    super.initState();
    // Set up connectivity
    _connectivity = Connectivity();
    _checkInternetConnection();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });

    // Load the user profile using the factory
    ProfileFactory profileFactory = StorageProfileFactory(_storageService);
    _userProfile = profileFactory.createProfile();
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    bool connected = result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
    setState(() {
      _isConnected = connected;
    });
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  Future<void> logoutAction(BuildContext context) async {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection. Please try again.')),
      );
      return;
    }

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
                    onPressed: _isConnected ? () => logoutAction(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isConnected ? SustainUColors.coralOrange : Colors.grey,
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
                  if (!_isConnected) ...[
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _checkInternetConnection,
                      child: Text('Retry', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No Internet Connection, To Logout Please Connect To Inernet',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

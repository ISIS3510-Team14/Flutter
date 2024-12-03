import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/utils/sustainu_colors.dart';
import '../../data/services/storage_service.dart';

class UserProfile {
  final String nickname;
  final String email;
  final String? profilePicture;
  final int totalPoints;
  final String? career;
  final String? semester;

  UserProfile({
    required this.nickname,
    required this.email,
    this.profilePicture,
    this.totalPoints = 0,
    this.career,
    this.semester,
  });
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isConnected = true;
  final StorageService _storageService = StorageService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Auth0 auth0 = Auth0(
    'dev-0jbbiqg2ogpddh7c.us.auth0.com',
    'wS0DhmlsFTG8UArvrikDn4q2sunD2J0p',
  );

  Future<UserProfile>? _userProfile;
  late Connectivity _connectivity;

  // Controladores para carrera y semestre
  final TextEditingController _careerController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();

  // Bandera para persistencia local de datos
  Map<String, dynamic> _localData = {};

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _checkInternetConnection();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });

    _userProfile = _loadUserProfile();
  }

  Future<UserProfile> _loadUserProfile() async {
    // Pre-declare and reuse variables to avoid redundant object creation
    Map<String, dynamic>? credentials = await _storageService.getUserCredentials();
    String email = credentials?['email'] ?? 'Unknown Email';

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(email).get();
    DocumentSnapshot userInfoDoc = await _firestore.collection('users_info').doc(email).get();

    if (!userInfoDoc.exists) {
      // Initialize default values only once when the document does not exist
      await _firestore.collection('users_info').doc(email).set({
        'career': '',
        'semester': '',
      });
    }

    // Consolidate data extraction with explicit casting
    Map<String, dynamic> userData = (userDoc.data() as Map<String, dynamic>? ?? {});
    Map<String, dynamic> userInfoData = (userInfoDoc.data() as Map<String, dynamic>? ?? {});

    // Update controller values directly without creating new objects
    _careerController.text = userInfoData['career'] ?? '';
    _semesterController.text = userInfoData['semester'] ?? '';

    // Update local data efficiently
    _localData = {
      'nickname': credentials?['nickname'] ?? 'Unknown User',
      'email': email,
      'profilePicture': credentials?['picture'],
      'totalPoints': userData['points']?['total'] ?? 0,
      'career': _careerController.text,
      'semester': _semesterController.text,
    };

    // Return updated profile without redundant variables
    return UserProfile(
      nickname: _localData['nickname'],
      email: _localData['email'],
      profilePicture: _localData['profilePicture'],
      totalPoints: _localData['totalPoints'],
      career: _localData['career'],
      semester: _localData['semester'],
    );
  }

  Future<void> _saveProfile(String email, String? career, String? semester) async {
    // Check for connectivity before proceeding
    if (!_isConnected) {
      _showNoInternetMessage();
      return;
    }

    try {
      // Consolidate Firestore write operation to prevent redundant object creation
      await _firestore.collection('users_info').doc(email).set({
        'career': career,
        'semester': semester,
      }, SetOptions(merge: true));

      // Update local data efficiently
      _localData['career'] = career;
      _localData['semester'] = semester;

      // Avoid redundant setState calls
      setState(() {
        _userProfile = Future.value(UserProfile(
          nickname: _localData['nickname'],
          email: _localData['email'],
          profilePicture: _localData['profilePicture'],
          totalPoints: _localData['totalPoints'],
          career: _localData['career'],
          semester: _localData['semester'],
        ));
      });

      // Inform the user of success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      // Catch and handle errors
      print('Failed to save profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile. Please try again.')),
      );
    }
  }


  Future<void> logoutAction(BuildContext context) async {
    if (!_isConnected) {
      _showNoInternetMessage();
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

  void _showNoInternetMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No internet connection. Cannot perform this action.')),
    );
  }

  double _calculateCompletion(UserProfile profile) {
    int completedFields = 0;
    int totalFields = 4; // nickname, email, career, semester

    if (profile.nickname.isNotEmpty) completedFields++;
    if (profile.email.isNotEmpty) completedFields++;
    if (_careerController.text.isNotEmpty) completedFields++;
    if (_semesterController.text.isNotEmpty) completedFields++;

    return completedFields / totalFields;
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
          //final completionPercentage = _calculateCompletion(userProfile);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                  SizedBox(height: 20),
                  Text(
                    'Total Points: ${userProfile.totalPoints}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: SustainUColors.limeGreen,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _careerController,
                    decoration: InputDecoration(
                      labelText: 'Career',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _semesterController,
                    keyboardType: TextInputType.number, // Ensures the keyboard shows numbers
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Filters non-numeric input
                    decoration: InputDecoration(
                      labelText: 'Semester',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isConnected
                        ? () => _saveProfile(userProfile.email, _careerController.text, _semesterController.text)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isConnected ? SustainUColors.limeGreen : SustainUColors.background,
                      minimumSize: Size(200, 50),
                    ),
                    child: Text('Save Profile'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _isConnected ? () => logoutAction(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isConnected ? SustainUColors.coralOrange : SustainUColors.background,
                      minimumSize: Size(200, 50),
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
                  SizedBox(height: 10),
                  if (!_isConnected)
                    Text(
                      'No internet connection. Cannot edit profile or logout.',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
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

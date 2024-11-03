import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; 
import '../../data/services/storage_service.dart';

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final StorageService _storageService = StorageService();
  bool _isConnected = true;
  String? _profilePictureUrl; 

  @override
  void initState() {
    super.initState();
    _loadInitialData(); 
    
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _checkInternetConnection();
    });
  }

  Future<void> _loadInitialData() async {
    await _checkInternetConnection();
    
    _profilePictureUrl = await _loadUserProfilePicture();
   
    setState(() {});
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
    });
  }

  Future<String?> _loadUserProfilePicture() async {
    Map<String, dynamic>? credentials =
        await _storageService.getUserCredentials();
    return credentials?['picture'];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/logo (1).png',
          height: 50,
        ),
        if (!_isConnected)
          Icon(
            Icons.wifi_off,
            color: Colors.red,
            size: 28,
          )
        else
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: CircleAvatar(
              radius: 24,
              backgroundImage: _profilePictureUrl != null && _profilePictureUrl!.isNotEmpty
                  ? NetworkImage(_profilePictureUrl!)
                  : null, 
              child: _profilePictureUrl == null || _profilePictureUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 24,
                      color: Colors.white,
                    )
                  : null, 
            ),
          ),
      ],
    );
  }
}

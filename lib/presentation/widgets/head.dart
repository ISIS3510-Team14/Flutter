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
    
    String? cachedPictureUrl = await _storageService.getCachedProfilePicture();
  
    if (cachedPictureUrl == null) {
      Map<String, dynamic>? credentials = await _storageService.getUserCredentials();
      cachedPictureUrl = credentials?['picture'];
      if (cachedPictureUrl != null) {
        await _storageService.cacheProfilePicture(cachedPictureUrl);
      }
    }
    
    return cachedPictureUrl;
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
        Expanded(
          child: Center(
            child: _isConnected
                ? Text(
                    '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        color: Colors.red,
                        size: 28,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'No Internet Connection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: CircleAvatar(
            radius: 24,
            backgroundImage: _profilePictureUrl != null
                ? NetworkImage(_profilePictureUrl!)
                : null,
            child: _profilePictureUrl == null
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

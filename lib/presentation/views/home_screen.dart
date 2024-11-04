import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Importing connectivity package
import '../../core/utils/sustainu_colors.dart';
import '../widgets/head.dart';
import '../widgets/bottom_navbar.dart';
import '../../data/services/storage_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = 'User';
  final StorageService _storageService = StorageService();
  bool _isConnected = true; // Track internet connection status
  late Connectivity _connectivity;
  List<File> _tempImages = [];

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _checkInternetConnection();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
    _loadUserProfile();
    _loadTemporaryImages(); // Now handles showing dialog internally
  }

  Future<void> _loadUserProfile() async {
    Map<String, dynamic>? credentials =
        await _storageService.getUserCredentials();
    setState(() {
      _name = credentials?['nickname'] ?? 'User';
    });
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    bool connected = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;

    if (!connected && _isConnected) {
      _showNoInternetDialog(); // Show dialog if connection is lost
    }

    setState(() {
      _isConnected = connected;
    });
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkInternetConnection();
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  Future<List<File>> _loadTemporaryImages() async {
    final directory = await getTemporaryDirectory();
    print(directory.path);
    final tempImages = Directory(directory.path);
    List<File> images = [];

    if (await tempImages.exists()) {
      // List all files in the directory
      final items = tempImages.listSync();
      images = items.whereType<File>().toList(); // Ensure we only get files
    }

    // Check for internet connection
    bool hasInternet = _isConnected;
    if (hasInternet) {
      if (images.isNotEmpty) {
        _showImageDialog(images);
      } else {
        _showNoImagesDialog(); // Show popup if no images are found
      }
    }

    return images; // Return the loaded images
  }

  void _showNoImagesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No Temporary Images'),
          content: Text('No temporary images are available at the moment.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showImageDialog(List<File> images) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Temporary Images Loaded'),
          content:
              Text('You have images available. Would you like to view them?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, '/viewImages', arguments: images);
              },
              child: Text('View Images'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            HeaderWidget(),
            SizedBox(height: 20),
            Text(
              'Hi, $_name',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: SustainUColors.text,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your record',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: SustainUColors.text,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '68 Points',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      '99 Days',
                      style: TextStyle(
                        color: SustainUColors.lightBlue,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildFlatButton(
                  'See green points',
                  'assets/iconMap.svg',
                  SustainUColors.limeGreen,
                  '/map',
                ),
                _buildFlatButton(
                  'See Scoreboard',
                  'assets/iconScoreboard.svg',
                  SustainUColors.limeGreen,
                  '/scoreboard',
                ),
                _buildFlatButton(
                  'What can I recycle?',
                  'assets/iconRecycle.svg',
                  SustainUColors.limeGreen,
                  '/recycle',
                ),
                _buildFlatButton(
                  'History',
                  Icons.calendar_month,
                  SustainUColors.limeGreen,
                  '/history',
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    'Start Recycling!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/camera');
                    },
                    child: Text(
                      'Scan',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Montserrat'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SustainUColors.limeGreen,
                      minimumSize: Size(200, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlatButton(
      String label, dynamic icon, Color color, String route) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon is String
                  ? SvgPicture.asset(
                      icon,
                      height: 40,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    )
                  : Icon(icon, color: color, size: 40),
              SizedBox(height: 10),
              Text(label, style: TextStyle(fontFamily: 'Montserrat')),
            ],
          ),
        ),
      ),
    );
  }
}

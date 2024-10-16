import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/utils/sustainu_colors.dart';
import '../widgets/head.dart';
import '../widgets/bottom_navbar.dart';
import '../../data/services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = 'User';
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    Map<String, dynamic>? credentials = await _storageService.getUserCredentials();
    setState(() {
      _name = credentials?['nickname'] ?? 'User';
    });
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

            // GridView to display buttons with local SVG assets
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
                      style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
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

  Widget _buildFlatButton(String label, dynamic icon, Color color, String route) {
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
                  ? SvgPicture.asset( // Carga el archivo desde assets
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

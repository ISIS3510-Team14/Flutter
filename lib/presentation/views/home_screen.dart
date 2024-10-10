import 'package:flutter/material.dart';
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
    _loadUserName(); 
  }

  Future<void> _loadUserName() async {
    String? name = await _storageService.getUserName();
    setState(() {
      _name = name ?? 'User';  
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              height: 120,  
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
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
                      Text('68 Points', style: TextStyle(fontFamily: 'Montserrat')),  
                      Text('99 Days', style: TextStyle(color: SustainUColors.lightBlue, fontFamily: 'Montserrat')),  
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,  
              mainAxisSpacing: 10,  
              crossAxisSpacing: 10,  
              shrinkWrap: true,  
              physics: NeverScrollableScrollPhysics(), 
              children: [
                _buildGridButton('See green points', Icons.place, SustainUColors.limeGreen),
                _buildGridButton('See Scoreboard', Icons.leaderboard, SustainUColors.limeGreen),
                _buildGridButton('What can I recycle?', Icons.recycling, SustainUColors.limeGreen),
                _buildGridButton('History', Icons.history, SustainUColors.limeGreen),
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
                    child: Text('Scan', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat')),  
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

  Widget _buildGridButton(String label, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: color, size: 40),  
                  SizedBox(height: 10),
                  Text(label, style: TextStyle(fontFamily: 'Montserrat')),  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

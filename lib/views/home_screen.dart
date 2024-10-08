import 'package:flutter/material.dart';
import '../utils/sustanu_colors.dart';
import '../widgets/head.dart';
import '../widgets/bottom_navbar.dart'; 

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Extract the user's name from the arguments passed to the route
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String userName = args['name'] ?? 'User';  // Fallback to 'User' if name is null

    return Scaffold(
      backgroundColor: SustainUColors.background,
      bottomNavigationBar: BottomNavBar(),  
      body: SingleChildScrollView(  
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              HeaderWidget(),
              SizedBox(height: 20),
              // Display the user's name dynamically
              Text(
                'Hi, $userName',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',  
                  color: SustainUColors.text,
                ),
              ),
              SizedBox(height: 10),

              // Card principal
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

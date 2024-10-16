import 'package:flutter/material.dart';
import '../../core/utils/sustainu_colors.dart';
import '../widgets/head.dart';
import '../widgets/bottom_navbar.dart';

class ScoreboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      
      bottomNavigationBar: BottomNavBar(currentIndex: 4),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(),
            SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.leaderboard, size: 80, color: SustainUColors.limeGreen),
                  SizedBox(height: 20),
                  Text(
                    'Scoreboard View...',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SustainUColors.text,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'coming soon, get ready to rule the leaderboard',
                    style: TextStyle(
                      fontSize: 16,
                      color: SustainUColors.text,
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
}

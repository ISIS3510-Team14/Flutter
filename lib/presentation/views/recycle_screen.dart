import 'package:flutter/material.dart';
import '../../core/utils/sustainu_colors.dart';
import '../widgets/head.dart';
import '../widgets/bottom_navbar.dart';

class RecycleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
              child: HeaderWidget(),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.recycling,
                      size: 80, color: SustainUColors.limeGreen),
                  SizedBox(height: 20),
                  Text(
                    'Recycle View...',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SustainUColors.text,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'coming soon to help you save the planet',
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

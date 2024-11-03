import 'package:flutter/material.dart';
import '../../../core/utils/sustainu_colors.dart';
import '../../widgets/head.dart';
import '../../widgets/bottom_navbar.dart';

class GlassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            HeaderWidget(),
          
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: SustainUColors.limeGreen),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 8),
                Text(
                  'Glass',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: SustainUColors.text,
                  ),
                ),
                SizedBox(width: 5),
                Image.asset(
                  'assets/glass.png',
                  height: 30,
                  width: 30,
                ),
              ],
            ),
            
            
            SizedBox(height: 20),

            
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Glass can be endlessly recycled without losing quality.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: SustainUColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Glass is most of the time thrown in the blue trash can',
                    style: TextStyle(
                      fontSize: 16,
                      color: SustainUColors.text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 16),
                Image.asset(
                  'assets/trash_blue.png',
                  height: 100,
                ),
              ],
            ),
            SizedBox(height: 20),

            
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'If you can you might want to separate colored glass, as mixing them can reduce recyclability.',
                  style: TextStyle(
                    fontSize: 16,
                    color: SustainUColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

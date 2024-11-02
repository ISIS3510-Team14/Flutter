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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(),
                  SizedBox(height: 20),
                  Text(
                    'Residues:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: SustainUColors.text,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final categories = [
                          {
                            'label': 'Paper',
                            'icon': 'assets/paper.png',
                            'subLabel': 'Boxes, magazines, notepads',
                            'route': '/paper'
                          },
                          {
                            'label': 'Plastic',
                            'icon': 'assets/plastic.png',
                            'subLabel': 'Packages, PET, bottles',
                            'route': '/plastic'
                          },
                          {
                            'label': 'Glass',
                            'icon': 'assets/glass.png',
                            'subLabel': 'Bottles, containers',
                            'route': '/glass'
                          },
                          {
                            'label': 'Metal',
                            'icon': 'assets/metal.png',
                            'subLabel': 'Cans, utensils',
                            'route': '/metal'
                          },
                        ];

                        return _buildCategoryButton(
                          context,
                          categories[index]['label']!,
                          categories[index]['icon']!,
                          categories[index]['subLabel']!,
                          categories[index]['route']!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String label,
    String icon,
    String subLabel,
    String route,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 50,
              fit: BoxFit.cover, 
            ),
            SizedBox(height: 8), 
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Text(
              subLabel,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

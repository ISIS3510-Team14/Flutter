import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  
import '../utils/sustainu_colors.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: SustainUColors.background,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: SustainUColors.limeGreen,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.network(
            'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logos/iconHome.svg',
            height: 24,
            placeholderBuilder: (context) => CircularProgressIndicator(), // Muestra un placeholder mientras carga el SVG
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.network(
            'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logos/iconMap.svg',
            height: 24,
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.network(
            'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logos/iconCamera.svg',
            height: 24,
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.network(
            'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logos/iconRecycle.svg',
            height: 24,
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          label: 'Recycle',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.network(
            'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logos/iconScoreboard.svg',
            height: 24,
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          label: 'Scoreboard',
        ),
      ],
      onTap: (index) {
        // Lógica para cambiar de pantalla según el índice
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/map');
            break;
          case 2:
            Navigator.pushNamed(context, '/camera');
            break;
          case 3:
            Navigator.pushNamed(context, '/recycle');
            break;
          case 4:
            Navigator.pushNamed(context, '/scoreboard');
            break;
        }
      },
    );
  }
}

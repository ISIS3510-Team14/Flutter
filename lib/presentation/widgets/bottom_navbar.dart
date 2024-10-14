import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/utils/sustainu_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  BottomNavBar({required this.currentIndex}); 

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: SustainUColors.background,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: SustainUColors.limeGreen,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.network(
            'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logos/iconHome.svg',
            height: 24,
            colorFilter: currentIndex == 0
                ? ColorFilter.mode(SustainUColors.limeGreen, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.network(
            'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logos/iconMap.svg',
            height: 24,
            colorFilter: currentIndex == 1
                ? ColorFilter.mode(SustainUColors.limeGreen, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.network(
            'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logos/iconCamera.svg',
            height: 24,
            colorFilter: currentIndex == 2
                ? ColorFilter.mode(SustainUColors.limeGreen, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.network(
            'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logos/iconRecycle.svg',
            height: 24,
            colorFilter: currentIndex == 3
                ? ColorFilter.mode(SustainUColors.limeGreen, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          label: 'Recycle',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.network(
            'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logos/iconScoreboard.svg',
            height: 24,
            colorFilter: currentIndex == 4
                ? ColorFilter.mode(SustainUColors.limeGreen, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          label: 'Scoreboard',
        ),
      ],
      onTap: (index) {
        
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

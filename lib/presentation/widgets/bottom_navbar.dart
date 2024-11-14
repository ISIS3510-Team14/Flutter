import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sustain_u/data/services/firestore_service.dart';
import '../../core/utils/sustainu_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final FirestoreService _firestoreService = FirestoreService();

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
          icon: SvgPicture.asset(
            'assets/iconHome.svg',
            height: 24,
            colorFilter: currentIndex == 0
                ? ColorFilter.mode(SustainUColors.limeGreen, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/iconMap.svg',
            height: 24,
            colorFilter: currentIndex == 1
                ? ColorFilter.mode(SustainUColors.limeGreen, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/iconCamera.svg',
            height: 24,
            colorFilter: currentIndex == 2
                ? ColorFilter.mode(SustainUColors.limeGreen, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/iconRecycle.svg',
            height: 24,
            colorFilter: currentIndex == 3
                ? ColorFilter.mode(SustainUColors.limeGreen, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          label: 'Recycle',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/iconScoreboard.svg',
            height: 24,
            colorFilter: currentIndex == 4
                ? ColorFilter.mode(SustainUColors.limeGreen, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
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
            _firestoreService.incrementMapAccessCount("nav");
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

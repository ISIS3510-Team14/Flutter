import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Image.network(
          'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logo.png',
          height: 50,
        ),
        // Profile picture (clickable)
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/pp.png', 
            ),
          ),
        ),
      ],
    );
  }
}

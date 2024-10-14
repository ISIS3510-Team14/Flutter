import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       
        Image.network(
          'https://raw.githubusercontent.com/ISIS3510-Team14/Data/master/logo.png',
          height: 50,
        ),
        
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue, 
            child: Icon(
              Icons.flutter_dash, 
              size: 30,
              color: Colors.white, 
            ),
          ),
        ),
      ],
    );
  }
}

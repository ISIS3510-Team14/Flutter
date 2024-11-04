import 'package:flutter/material.dart';
import '../../core/utils/sustainu_colors.dart';



class InstructionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 3.0, right: 16.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: SustainUColors.limeGreen),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              
            ),
            
          
            SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline,
                      size: 80, color: SustainUColors.limeGreen),
                  SizedBox(height: 20),
                  Text(
                    'Instructions',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SustainUColors.text,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InstructionText(
                        '1. The email must belong to the @uniandes.edu.co domain.',
                      ),
                      SizedBox(height: 10),
                      InstructionText(
                        '2. The email must not contain any special characters, except ".", "-", and "_".',
                      ),
                      SizedBox(height: 10),
                      InstructionText(
                        '3. The name should have no special characters, with a maximum of 50 characters and a minimum of 3.',
                      ),
                    ],
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

class InstructionText extends StatelessWidget {
  final String text;
  InstructionText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        color: SustainUColors.text,
      ),
      textAlign: TextAlign.left,
    );
  }
}

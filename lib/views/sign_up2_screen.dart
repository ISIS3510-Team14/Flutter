import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils/sustainu_colors.dart';

class SignUp2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back Button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: SustainUColors.limeGreen),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(height: 20),
            // Welcome Text
            Text(
              'Welcome!',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 32,
                color: SustainUColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            // Phone Number Field (only accepts numbers)
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone number',
                labelStyle: TextStyle(color: SustainUColors.textLight),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: SustainUColors.limeGreen,
                    width: 2.0,
                  ),
                ),
              ),
              keyboardType: TextInputType.phone, 
            ),
            SizedBox(height: 20),
            // Zip Code Field (only accepts numbers)
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Zip code',
                labelStyle: TextStyle(color: SustainUColors.textLight),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: SustainUColors.limeGreen,
                    width: 2.0,
                  ),
                ),
              ),
              keyboardType: TextInputType.number, 
            ),
            SizedBox(height: 20),
            // Number Field (only accepts numbers)
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Number',
                labelStyle: TextStyle(color: SustainUColors.textLight),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: SustainUColors.limeGreen,
                    width: 2.0,
                  ),
                ),
              ),
              keyboardType: TextInputType.number, 
            ),
            SizedBox(height: 30),
            // Sign Up Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sign_in');
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SustainUColors.limeGreen,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), 
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // "Already have an account? Sign in" Text Button
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Already have an account?\n',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: SustainUColors.text,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign in',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: SustainUColors.limeGreen,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/sign_in');
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

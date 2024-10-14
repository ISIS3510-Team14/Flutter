import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/utils/sustainu_colors.dart';
import '../widgets/custom_button.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscurePassword = true;

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
            
            Text(
              'Welcome back!',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 32,
                color: SustainUColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  color: SustainUColors.textLight,
                ),
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
            ),
            SizedBox(height: 20),
            
            
            TextFormField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  color: SustainUColors.textLight,
                ),
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
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: SustainUColors.limeGreen,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot_password');
                },
                child: Text(
                  'Forgot your password?',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: SustainUColors.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            
            CustomButton(
              text: 'Sign In',

              color: SustainUColors.limeGreen,
              onPressed: () {
                
              },
            ),
          ],
        ),
      ),
    );
  }
}

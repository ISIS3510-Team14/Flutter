import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool isAuthenticated = false;

  void signIn(String phoneNumber, String zipCode) {
    // Logic for sign in
    isAuthenticated = true;
    notifyListeners();
  }
  
  void signOut() {
    isAuthenticated = false;
    notifyListeners();
  }
}

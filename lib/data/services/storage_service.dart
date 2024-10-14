import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userCredentialsKey = 'userCredentials';

  Future<void> saveUserCredentials(Map<String, dynamic> credentials) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String credentialsJson = jsonEncode(credentials);
    await prefs.setString(_userCredentialsKey, credentialsJson);
  }

  Future<Map<String, dynamic>?> getUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? credentialsJson = prefs.getString(_userCredentialsKey);
    if (credentialsJson != null) {
      return jsonDecode(credentialsJson);
    }
    return null;
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userCredentialsKey);
  }
}

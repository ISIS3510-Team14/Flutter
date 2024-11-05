import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userCredentialsKey = 'userCredentials';
  static const String _cachedProfilePictureKey = 'cachedProfilePicture';

  // Save user credentials
  Future<void> saveUserCredentials(Map<String, dynamic> credentials) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String credentialsJson = jsonEncode(credentials);
    await prefs.setString(_userCredentialsKey, credentialsJson);
  }

  // Retrieve user credentials
  Future<Map<String, dynamic>?> getUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? credentialsJson = prefs.getString(_userCredentialsKey);
    if (credentialsJson != null) {
      return jsonDecode(credentialsJson);
    }
    return null;
  }

  // Clear user data
  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userCredentialsKey);
    await prefs.remove(_cachedProfilePictureKey); // Clear cached profile picture as well
  }

  // Cache profile picture URL
  Future<void> cacheProfilePicture(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedProfilePictureKey, url);
  }

  // Retrieve cached profile picture URL
  Future<String?> getCachedProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cachedProfilePictureKey);
  }
}

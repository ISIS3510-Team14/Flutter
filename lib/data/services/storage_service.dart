import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userNameKey = 'userName';

  // Guardar el nombre de usuario en SharedPreferences
  Future<void> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, userName);
  }

  // Obtener el nombre de usuario de SharedPreferences
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Limpiar los datos guardados (puedes usar esto para el logout)
  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
  }
}

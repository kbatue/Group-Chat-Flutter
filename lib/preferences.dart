import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;

  static const _keyEmail = 'email';
  static const _keyPassword = 'password';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static String? getUserEmail() {
    return _preferences?.getString(_keyEmail);
  }

  static String? getUserPassword() {
    return _preferences?.getString(_keyPassword);
  }

  static void setUserPassword(String password) async {
    await _preferences?.setString(_keyPassword, password);
  }

  static void setUserEmail(String email) async {
    await _preferences?.setString(_keyEmail, email);
  }
}

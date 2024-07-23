// lib/shared_preferences.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String? get username => _preferences?.getString('username');

  static String? get password => _preferences?.getString('password');

  static Future<void> setUsername(String username) async {
    await _preferences?.setString('username', username);
  }

  static Future<void> setPassword(String password) async {
    await _preferences?.setString('password', password);
  }

  static Future<void> clear() async {
    await _preferences?.clear();
  }
}
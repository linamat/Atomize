import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  static Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  static Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}

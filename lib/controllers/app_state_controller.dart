import 'package:flutter/material.dart';
import 'package:atomize/common/services/shared_prefs_service.dart';
import 'package:atomize/common/constants/shared_prefs_keys.dart';

class AppStateController extends ChangeNotifier {
  bool _isDarkMode = false;
  Locale _locale = const Locale('en');
  Color _primaryColor = const Color(0xFF2196F3);

  bool _initialized = false;
  bool get initialized => _initialized;

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;
  Color get primaryColor => _primaryColor;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> load() async {
    _isDarkMode = await _getBool(SharedPrefsKeys.isDarkMode, defaultValue: false);
    _locale = Locale(
      await _getString(SharedPrefsKeys.locale, defaultValue: 'en'),
    );
    _primaryColor = Color(
      await _getInt(SharedPrefsKeys.primaryColor, defaultValue: 0xFF2196F3),
    );
    _initialized = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) => _updateSetting(
        () => _isDarkMode = value,
        () => SharedPrefsService.setBool(SharedPrefsKeys.isDarkMode, value),
      );

  Future<void> setLocale(Locale locale) => _updateSetting(
        () => _locale = locale,
        () => SharedPrefsService.setString(SharedPrefsKeys.locale, locale.languageCode),
      );

  Future<void> setPrimaryColor(Color color) => _updateSetting(
        () => _primaryColor = color,
        () => SharedPrefsService.setInt(SharedPrefsKeys.primaryColor, color.toARGB32()),
      );

  Future<void> _updateSetting(
    VoidCallback apply,
    Future<void> Function() persist,
  ) async {
    apply();
    await persist();
    notifyListeners();
  }

  Future<bool> _getBool(String key, {required bool defaultValue}) async =>
      (await SharedPrefsService.getBool(key)) ?? defaultValue;

  Future<String> _getString(String key, {required String defaultValue}) async =>
      (await SharedPrefsService.getString(key)) ?? defaultValue;

  Future<int> _getInt(String key, {required int defaultValue}) async =>
      (await SharedPrefsService.getInt(key)) ?? defaultValue;
}

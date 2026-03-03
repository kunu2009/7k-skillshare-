import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeProvider extends ChangeNotifier {
  static final ThemeProvider _instance = ThemeProvider._internal();

  factory ThemeProvider() {
    return _instance;
  }

  ThemeProvider._internal() {
    _loadTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;
  final _storage = GetStorage();
  static const String _themeKey = 'isDarkMode';

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme() {
    final isDark = _storage.read(_themeKey) ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _storage.write(_themeKey, isDarkMode);
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    _storage.write(_themeKey, isDarkMode);
    notifyListeners();
  }
}

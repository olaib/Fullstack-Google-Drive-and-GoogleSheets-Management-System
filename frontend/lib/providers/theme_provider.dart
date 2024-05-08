import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/utils/constants/constants.dart';

/// ThemeProvider is a class that provides the theme state of the app
/// The state of the theme is saved in the shared preferences - local storage for ios/android
/// When the system theme is dark, the app will be in dark mode
/// Otherwise, theme will be  based on system theme
class ThemeProvider with ChangeNotifier {
  static const themeStateKey = THEME_STATE_KEY;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() => setTheme(isDarkMode: !_isDarkMode);

  ThemeProvider() {
    init();
  }
  // load from disk

  Future<SharedPreferences> _getSharedPref() async =>
      await SharedPreferences.getInstance();

  Future<void> init() async {
    setTheme();
  }

  Future<void> setTheme({bool isDarkMode = false}) async {
    // if system theme is dark, so automatically set dark mode
    if (ThemeMode.system == ThemeMode.dark) {
      _isDarkMode = true;
      // theme based on system theme
    } else {
      SharedPreferences pref = await _getSharedPref();
      pref.setBool(themeStateKey, isDarkMode);
      _isDarkMode = isDarkMode;
    }
    notifyListeners();
  }
}

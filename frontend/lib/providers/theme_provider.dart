import 'package:flutter/material.dart';
import 'package:frontend/utils/storage/preference_utils.dart';
// ignore: depend_on_referenced_packages
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

  Future<void> init()async {
    _isDarkMode = PreferenceUtils.getBool(themeStateKey);
   await setTheme(isDarkMode: _isDarkMode);
  }

  Future<void> setTheme({bool isDarkMode = false}) async {
    await PreferenceUtils.setBool(themeStateKey, isDarkMode);
    _isDarkMode = isDarkMode;

    notifyListeners();
  }
}

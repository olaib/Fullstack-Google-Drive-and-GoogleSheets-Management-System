// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

/// A class that provides utility methods for shared preferences
/// load and save data from shared preferences( local storage for ios/android)
class PreferenceUtils {
  PreferenceUtils._();

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static SharedPreferences? _prefsInstance;

  static String getString(String key, [String? defValue]) {
    return _prefsInstance!.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    SharedPreferences prefs = await _instance;

    return prefs.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    SharedPreferences prefs = await _instance;
    return await prefs.setBool(key, value);
  }

  static bool getBool(String key, [bool? defValue]) {
    return _prefsInstance!.getBool(key) ?? defValue ?? false;
  }
}

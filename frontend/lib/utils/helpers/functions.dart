import 'package:frontend/injection_container.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class Helpers {
  static final ThemeProvider themeProvider = getIt<ThemeProvider>();
  Helpers._();

  static bool isWebPlatform() =>
      kIsWeb || defaultTargetPlatform == TargetPlatform.fuchsia;

  static bool get isDarkMode => themeProvider.isDarkMode;

  /// Compare two values.
  ///
  /// [a] the first value.
  ///
  /// [b] the second value.
  ///
  /// [ascending] the order of the comparison.
  static int compare(dynamic a, dynamic b, bool ascending) {
    // comare the values as numbers if they are numbers
    if (a is num && b is num) {
      return ascending ? a.compareTo(b) : b.compareTo(a);
    }
    // compare the values as strings
    return ascending
        ? a.toString().compareTo(b.toString())
        : b.toString().compareTo(a.toString());
  }
}

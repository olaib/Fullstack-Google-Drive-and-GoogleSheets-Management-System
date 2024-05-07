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
}

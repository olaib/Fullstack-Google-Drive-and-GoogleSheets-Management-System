import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget {
  ResponsiveWidget._();

  static bool isWeb()=> kIsWeb || defaultTargetPlatform == TargetPlatform.fuchsia;
}
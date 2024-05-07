import 'package:flutter/material.dart';

enum AppColor { red, green, blue, yellow }

class AppColors {
  AppColors._();

  static const colorsMap = <AppColor, Color>{
    AppColor.red: Colors.red,
    AppColor.green: Colors.green,
    AppColor.blue: Colors.blue,
    AppColor.yellow: Colors.yellow,
  };

  static Color getColor(AppColor color) {
    return colorsMap[color]!;
  }
}

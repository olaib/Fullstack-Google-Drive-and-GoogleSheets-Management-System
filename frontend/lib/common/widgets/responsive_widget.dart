import 'package:flutter/material.dart';
import 'package:frontend/utils/helpers/functions.dart';
import 'package:frontend/utils/constants/sizes.dart';

class ResponsiveWidget {
  ResponsiveWidget._();

  static bool isWeb(BuildContext context) => Helpers.isWebPlatform();

  static getScreenSize(BuildContext context) => MediaQuery.of(context).size;

  static bool isSmallScreen(BuildContext context) =>
      getScreenSize(context).width < SMALL_SCREEN_SIZE;

  static bool isMediumScreen(BuildContext context) {
    final width = getScreenSize(context).width;

    return width >= SMALL_SCREEN_SIZE && width < MEDIUM_SCREEN_SIZE;
  }

  static bool isLargeScreen(BuildContext context) =>
      getScreenSize(context).width >= MEDIUM_SCREEN_SIZE;
}

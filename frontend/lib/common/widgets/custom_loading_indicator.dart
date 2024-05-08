import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/utils/helpers/functions.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/helpers/responsive_widget.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveWidget.getScreenSize(context);
    return Center(
      child: SpinKitWave(
          color: Helpers.isDarkMode ? YELLOW_COLOR : BLUE_COLOR,
          size: size.width / 4),
    );
  }
}

class CustomDotLoadingIndicator extends StatelessWidget {
  const CustomDotLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveWidget.getScreenSize(context);
    return Center(
      child: SpinKitThreeBounce(
        color: Helpers.isDarkMode ? YELLOW_COLOR : BLUE_COLOR,
        size: size.width / 4,
      ),
    );
  }
}

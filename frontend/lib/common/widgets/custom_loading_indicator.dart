import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/utils/constants/app_colors.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/helpers/functions.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: Helpers.isDarkMode
            ? AppColors.getColor(AppColor.yellow)
            : AppColors.getColor(AppColor.blue),
        size: LOADING_SIZE,
      ),
    );
  }
}

class CustomDotLoadingIndicator extends StatelessWidget {
  const CustomDotLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: Helpers.isDarkMode
            ? AppColors.getColor(AppColor.yellow)
            : AppColors.getColor(AppColor.blue),
        size: LOADING_SIZE/2,
      ),
    );
  }
}
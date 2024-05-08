import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
<<<<<<< Updated upstream
import 'package:frontend/utils/constants/app_colors.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/helpers/functions.dart';
=======
import 'package:frontend/utils/helpers/functions.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/helpers/responsive_widget.dart';
>>>>>>> Stashed changes

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Center(
      child: SpinKitWave(
        color: Helpers.isDarkMode
            ? AppColors.getColor(AppColor.yellow)
            : AppColors.getColor(AppColor.blue),
        size: LOADING_SIZE,
      ),
=======
    final size = ResponsiveWidget.getScreenSize(context);
    return Center(
      child: SpinKitWave(
          color: Helpers.isDarkMode ? YELLOW_COLOR : BLUE_COLOR,
          size: size.width / 2),
>>>>>>> Stashed changes
    );
  }
}

class CustomDotLoadingIndicator extends StatelessWidget {
  const CustomDotLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
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
=======
    final size = ResponsiveWidget.getScreenSize(context);
    return Center(
      child: SpinKitThreeBounce(
        color: Helpers.isDarkMode ? YELLOW_COLOR : BLUE_COLOR,
        size: size.width / 2,
      ),
    );
  }
}
>>>>>>> Stashed changes

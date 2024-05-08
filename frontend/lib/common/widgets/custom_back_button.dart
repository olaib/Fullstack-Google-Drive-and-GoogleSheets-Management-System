import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/routes/app_routes.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const FaIcon(FontAwesomeIcons.circleLeft),
      onPressed: () => NavigationService.canPop(context)
          ? NavigationService.goBack(context)
          : NavigationService.navigateTo(context, Routes.home),
    );
  }
}

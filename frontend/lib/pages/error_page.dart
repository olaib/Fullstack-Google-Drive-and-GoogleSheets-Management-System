import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/extended_floating_action_button.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/constants/colors.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key, this.error});
  final GoException? error;

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    final is404 = widget.error?.message.contains('404') ?? false;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildTitle(is404 ? PAGE_NOT_FOUND_TITLE : GENERIC_ERROR_TITLE),
            const SizedBox(height: 10),
            buildMessage(is404),
            if (!is404)
              Text(
                widget.error?.message ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  color: RED_COLOR,
                ),
              ),
            buildHomeButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 100,
          color: RED_COLOR,
        ),
      );
  Widget buildMessage(bool is404) => const Text(
        MESSAGE_404,
        style: TextStyle(
          fontSize: 20,
          color: RED_COLOR,
        ),
      );

  Widget buildHomeButton(BuildContext context) => Center(
        child: Column(
          children: <Widget>[
            CustomExtendedFloatingActionButton(
              icon: Icons.home,
              label: const Text(HOME),
              tag: HOME,
              onPressed: () =>
                  NavigationService.navigateTo(context, Routes.home),
            ),
            CustomExtendedFloatingActionButton(
                icon: Icons.forward,
                label: const Text(BACK),
                tag: BACK,
                onPressed: () => NavigationService.canPop(context)
                    ? NavigationService.goBack(context)
                    : NavigationService.navigateTo(context, Routes.home)),
          ],
        ),
      );
}

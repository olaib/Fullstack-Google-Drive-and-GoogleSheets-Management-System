import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/helpers/functions.dart';
import 'package:frontend/common/widgets/custom_gesture_detector.dart';
import 'package:frontend/common/widgets/custom_back_button.dart';
import 'package:frontend/common/widgets/app_name_animated_text.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final _theme = getIt<ThemeProvider>();
  final _auth = getIt<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitleUI(),
      leading: Builder(
        builder: (BuildContext context) => IconButton(
          tooltip: MENU_TOOLTIP_NAME,
          icon: const Icon(Icons.list),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      shadowColor: Helpers.isDarkMode
          ? BLACK_COLOR.withOpacity(0.5)
          : PRIMARY_COLOR.withOpacity(0.5),
      elevation: 5.0,
      actions: [
        CustomGestureDetector(
          onTap: _theme.toggleTheme,
          icon: _theme.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        ),
        if (_auth.isAuthenticated)
          buildProfileMenu(context, _auth.user!.name, _auth.user!.email),
        if (NavigationService.canPop(context)) const CustomBackButton(),
        CustomGestureDetector(
          icon: Icons.cloud,
          onTap: () {
            NavigationService.navigateTo(context, Routes.googleDrive);
          },
        ),
      ],
    );
  }

  Future<void> _signout(BuildContext context) async {
    if (_auth.isAuthenticated) {
      await _auth.logout();
    }
    if (context.mounted) NavigationService.navigateTo(context, Routes.home);
  }

  Widget _buildTitleUI() => Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  NavigationService.navigateTo(context, Routes.initialRoute);
                },
                child: Row(
                  children: [
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(0.01)
                        ..rotateY(0.01)
                        ..rotateZ(0.01),
                      child: AppNameAnimatedText(
                        label: APP_NAME,
                        fontSize: 24,
                        color: Helpers.isDarkMode ? PRIMARY_COLOR : BLACK_COLOR,
                        baseColor:
                            Helpers.isDarkMode ? BLACK_COLOR : PRIMARY_COLOR,
                        highlightColor: Helpers.isDarkMode
                            ? WHITE_COLOR
                            : PRIMARY_COLOR.withOpacity(0.5),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      );
  //return popupmenu with settings and logout
  Widget buildProfileMenu(BuildContext context, String name, String email) {
    return PopupMenuButton<String>(
        onSelected: (String value) async {
          switch (value) {
            case 'logout':
              await _signout(context);
              if (context.mounted) {
                NavigationService.navigateTo(context, Routes.home);
              }
              break;
            case 'settings':
              NavigationService.navigateTo(context, Routes.settings);
              break;
          }
        },
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(FontAwesomeIcons.user),
                  title: Text(name),
                  subtitle: Text(email),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    NavigationService.navigateTo(context, Routes.settings);
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await _signout(context);
                  },
                ),
              ),
            ]);
  }
}

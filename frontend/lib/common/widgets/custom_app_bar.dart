import 'package:flutter/material.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/utils/helpers/functions.dart';
import 'package:frontend/utils/constants/constants.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  static final ThemeProvider _theme = getIt<ThemeProvider>();
  static final AuthProvider _auth = getIt<AuthProvider>();

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
          ? Colors.black
          : const Color.fromARGB(75, 255, 255, 255),
      elevation: 5.0,
      actions: const [],
    );
  }

  Widget _buildTitleUI() {
    return Text(
      APP_NAME,
      style: TextStyle(
        color: _theme.isDarkMode ? Colors.white : Colors.black,
        fontSize: 20,
      ),
    );
  }
}

import 'package:frontend/injection_container.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:frontend/utils/routes/nav_button.dart';
import 'package:frontend/utils/storage/preference_utils.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthProvider _authProvider = getIt<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 1,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildDrawerHeader(context),
          buildNavButtons(context),
          const Divider(),
          buildFooter(context),
        ],
      ),
    );
  }

  Widget buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: const Column(
        children: [
          FaIcon(
            FontAwesomeIcons.circleNotch,
            size: 50,
            color: Colors.white,
          ),
          SizedBox(height: 10),
          Text(
            APP_NAME,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavButtons(BuildContext context) {
    return Column(
      children: [
        ...navButtonsData.map((NavButton button) => ListTile(
              title: Text(button.title),
              leading: FaIcon(button.icon),
              onTap: () => NavigationService.navigateTo(context, button.route),
            )),
        //             NavButton(
        //   myIcon: FontAwesomeIcons.file,
        //   myRoute: Routes.googleDrive,
        //   name: 'Files',
        // ),
        ListTile(
          title: const Text('Manage Google Drive files'),
          leading: const FaIcon(FontAwesomeIcons.googleDrive),
          onTap: () => NavigationService.navigateTo(context, Routes.googleDrive,
              params: {ROOT_ID_PARAM: _loadGDriveRoottId()}),
        ),
      ],
    );
  }

  String _loadGDriveRoottId() {
    final gDriveId = PreferenceUtils.getString(GOOGLE_DRIVE_ID_KEY, '');
    Log.info('Google Drive ID: $gDriveId');
    if (gDriveId.isEmpty) {
      throw Exception('Google Drive ID is empty');
    }
    return gDriveId;
  }

  Widget buildFooter(BuildContext context) {
    return Column(
      children: [
        if (_authProvider.isAuthenticated)
          ListTile(
            title: const Text(SIGNOUT_TITLE),
            leading: const FaIcon(FontAwesomeIcons.rightFromBracket),
            onTap: () async => await _signout(context),
          ),
        ListTile(
          title: const Text(ABOUT_TITLE),
          leading: const FaIcon(FontAwesomeIcons.info),
          onTap: () {
            NavigationService.navigateTo(context, Routes.about);
          },
        ),
      ],
    );
  }

  Future<void> _signout(BuildContext context) async {
    await _authProvider.logout();
    if (context.mounted) NavigationService.navigateTo(context, Routes.home);
  }
}

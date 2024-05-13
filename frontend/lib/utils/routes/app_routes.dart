import 'package:frontend/utils/constants/constants.dart';

enum Routes {
  home,
  initialRoute,
  error,
  loginPage,
  about,
  sheetScreen,
  settings,
  googleDrive,
  filesPage,
}

class MyRoute {
  final String name, url;
  final Routes route;

  const MyRoute({
    required this.name,
    required this.url,
    required this.route,
  });
}

extension RoutesExtension on Routes {
  String get url => _routesMap[this]!.url;
  String get name => _routesMap[this]!.name;
  bool isEquals(String? route) => url == route;
}

final Map<Routes, MyRoute> _routesMap = {
  Routes.initialRoute: const MyRoute(
    name: 'Welcome page',
    url: '/',
    route: Routes.initialRoute,
  ),
  Routes.home: const MyRoute(
    name: 'Home',
    url: 'home',
    route: Routes.home,
  ),
  Routes.error: const MyRoute(
    name: 'Error',
    url: 'error',
    route: Routes.error,
  ),
  Routes.loginPage: const MyRoute(
    name: 'Login',
    url: 'login',
    route: Routes.loginPage,
  ),
  Routes.about: const MyRoute(
    name: 'About',
    url: 'about',
    route: Routes.about,
  ),
  Routes.sheetScreen: const MyRoute(
    name: 'Sheet',
    url: 'sheet/:sheetId/:title',
    route: Routes.sheetScreen,
  ),
  Routes.googleDrive: const MyRoute(
    name: 'Google Drive',
    url: 'google_drive/:$ROOT_ID_PARAM',
    route: Routes.googleDrive,
  ),
  Routes.filesPage: const MyRoute(
    name: 'File',
    url: 'files/:$FILE_ID_PARAM',
    route: Routes.filesPage,
  ),
};

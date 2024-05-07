import 'package:frontend/utils/constants/constants.dart';

enum Routes {
  home,
  error,
  loginPage,
  about,
  sheetScreen,
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
  Routes.home: const MyRoute(
    name: 'Home',
    url: '/',
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
    url: 'sheet?sheetId=:$SHEET_ID_PARAM&title=:$SHEET_TITLE_PARAM',
    route: Routes.sheetScreen,
  ),
};

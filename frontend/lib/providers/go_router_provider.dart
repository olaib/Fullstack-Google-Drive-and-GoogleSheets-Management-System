import 'package:flutter/material.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:frontend/utils/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/pages/index.dart';
import 'package:frontend/common/widgets/custom_app_bar.dart';
import 'package:frontend/common/widgets/custom_drawer.dart';

final _rootNavKey = GlobalKey<NavigatorState>(debugLabel: ROOT_NAV_KEY);

class GoRouterProvider {
  static GoRouterProvider? _instance;
  late final GoRouter _router;
  static final _authProvider = getIt<AuthProvider>();

  static final _routers = <RouteBase>[
    GoRoute(
      path: Routes.home.url,
      name: Routes.home.name,
      pageBuilder: (context, state) => buildMaterialPage(const HomePage()),
      routes: [
        GoRoute(
          path: Routes.error.url,
          name: Routes.error.name,
          pageBuilder: (context, state) => buildMaterialPage(const ErrorPage()),
        ),
        GoRoute(
            path: Routes.sheetScreen.url,
            name: Routes.sheetScreen.name,
            pageBuilder: (context, state) {
              return buildMaterialPage(
                  // todo: change to query parameters
                  SheetPage(
                      sheetId: state.uri.queryParameters[SHEET_ID_PARAM]!,
                      sheetTitle:
                          state.uri.queryParameters[SHEET_TITLE_PARAM]));
            })
      ],
    ),
  ];
  get router => _router;
  static get instance => _instance ??= GoRouterProvider._();

  GoRouterProvider._() : _router = _initRouter();

  static GoRouter _initRouter() {
    return GoRouter(
      debugLogDiagnostics: false,
      refreshListenable: _authProvider,
      navigatorKey: _rootNavKey,
      initialLocation: Routes.home.url,
      routes: _routers,
      redirect: (BuildContext context, GoRouterState state) async =>
          middleware(context, state),
      errorPageBuilder: (context, state) =>
          buildMaterialPage(const ErrorPage()),
    );
  }

  static middleware(BuildContext context, GoRouterState state) {
    try {
      final next = state.uri.toString();
      return next;
    } catch (error) {
      return '${Routes.error.url}/$error';
    }
  }

  static MaterialPage buildMaterialPage(Widget widget) => MaterialPage(
      child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: MIN_WIDTH,
            minHeight: MIN_HEIGHT,
          ),
          child: Scaffold(
            appBar: const CustomAppBar(),
            drawer: const CustomDrawer(),
            drawerEdgeDragWidth: 0,
            body: widget,
          )));
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/injection_container.dart' as di;
import 'package:frontend/injection_container.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/go_router_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupApp().then((_) => runApp(const App()));
}

Future<void> _setupApp() async {
  await di.init();
}

class App extends StatelessWidget {
  const App({super.key});
  static final GoRouterProvider _routerProvider = GoRouterProvider.instance;
  static final AuthProvider _authProvider = getIt<AuthProvider>();
  static final ThemeProvider themeProvider = getIt<ThemeProvider>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => themeProvider),
        ChangeNotifierProvider<AuthProvider>(create: (_) => _authProvider),
      ],
      child: MaterialApp.router(
        title: APP_NAME,
        routerConfig: _routerProvider.router,
        themeMode: themeProvider.themeMode,
        // theme: themeProvider.theme,
        // darkTheme: themeProvider.darkTheme,
      ),
    );
  }
}

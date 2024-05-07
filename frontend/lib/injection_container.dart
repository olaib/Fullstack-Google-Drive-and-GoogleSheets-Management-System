import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void init() {
  Log.info('Initializing dependency injection container');

  getIt.registerSingleton<ThemeProvider>(ThemeProvider());
  Log.debug('Theme provider registered');

  getIt.registerSingleton<AuthProvider>(AuthProvider());
  Log.debug('Auth provider registered');

  getIt.registerSingleton<NavigationService>(NavigationService());
  Log.debug('Navigation service registered');
  
  Log.info('Dependency injection container initialized');
}

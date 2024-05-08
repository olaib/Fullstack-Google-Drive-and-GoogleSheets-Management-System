import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
<<<<<<< Updated upstream
import 'package:frontend/services/HttpServices.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/constants/env.dart';
import 'package:frontend/utils/logger/logger.dart';
=======
>>>>>>> Stashed changes
import 'package:get_it/get_it.dart';
import 'package:frontend/utils/constants/env.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/services/HttpServices.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
<<<<<<< Updated upstream
  Log.info('Initializing dependency injection container');
  await dotenv.load().then((_) => Log.debug('Loaded .env file'));
=======
  Log.info('Initializing dependency injection container...');

  await dotenv.load().then((_) => Log.debug('Loaded .env file'));

>>>>>>> Stashed changes
  if (!dotenv.isEveryDefined([SERVER_URL_KEY])) {
    throw Exception('Please define\n - $SERVER_URL_KEY\nin your .env file');
  }

  getIt.registerSingleton<ThemeProvider>(ThemeProvider());
  Log.debug('Theme provider registered');

  getIt.registerSingleton<AuthProvider>(AuthProvider());
  Log.debug('Auth provider registered');

<<<<<<< Updated upstream
  getIt.registerSingleton<HttpServices>(
      HttpServices(dotenv.env[SERVER_URL_KEY]));

  getIt.registerSingleton<NavigationService>(NavigationService());
  Log.debug('Navigation service registered');
=======
  getIt.registerSingleton<HttpServices>(HttpServices(dotenv.env[SERVER_URL_KEY]!));
>>>>>>> Stashed changes

  Log.info('Dependency injection container initialized');
}

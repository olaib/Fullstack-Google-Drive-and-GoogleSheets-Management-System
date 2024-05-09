// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/storage/preference_utils.dart';

import 'package:get_it/get_it.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:frontend/services/http_services.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  Log.info('Initializing dependency injection container...');
  await PreferenceUtils.init();

  // await dotenv.load().then((_) => Log.debug('Loaded .env file'));

  // if (!dotenv.isEveryDefined([SERVER_URL_KEY])) {
  //   throw Exception('Please define\n - $SERVER_URL_KEY\nin your .env file');
  // }

  getIt.registerSingleton<ThemeProvider>(ThemeProvider());
  Log.debug('Theme provider registered');

  getIt.registerSingleton<AuthProvider>(AuthProvider());
  Log.debug('Auth provider registered');

  getIt.registerSingleton<HttpServices>(HttpServices(SERVER_URL));

  Log.info('Dependency injection container initialized');
}

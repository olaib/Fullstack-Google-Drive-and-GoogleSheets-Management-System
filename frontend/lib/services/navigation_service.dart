import 'package:flutter/material.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:frontend/utils/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/logger/logger.dart';

class NavigationService {
  NavigationService._();
  static final NavigationService _instance = NavigationService._();

  factory NavigationService() {
    return _instance;
  }


<<<<<<< Updated upstream
  void navigateTo(BuildContext context, Routes route, {Map<String, String>? params,Map<String, String>? queryParams}) {
    Log.debug('Navigating to ${route.name} with params: $params');
context.goNamed(route.name, pathParameters: {...?params}, queryParameters: {...?queryParams});
=======
  static void navigateTo(BuildContext context, Routes route,
      {Map<String, String>? params, Map<String, String>? queryParams}) {
    Log.debug('Navigating to ${route.name} with params: $params');
    context.goNamed(route.name,
        pathParameters: {...?params}, queryParameters: {...?queryParams});
>>>>>>> Stashed changes
  }

  static void goBack(BuildContext context) {
    if (canPop(context)) context.pop();
  }

  static bool canPop(BuildContext context) => context.canPop();
}

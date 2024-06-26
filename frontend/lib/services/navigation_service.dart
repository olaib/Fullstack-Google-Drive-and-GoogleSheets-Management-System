import 'package:flutter/material.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:frontend/utils/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
export 'package:frontend/utils/routes/app_routes.dart';

class NavigationService {
  NavigationService._();
  static final NavigationService _instance = NavigationService._();

  factory NavigationService() {
    return _instance;
  }

  static void navigateTo(BuildContext context, Routes route,
      {Map<String, String>? params, Map<String, String>? queryParams}) {
    Log.debug('Navigating to ${route.url} with params: $params');
    context.goNamed(route.name,
        pathParameters: {...?params}, queryParameters: {...?queryParams});
  }

  static void goBack(BuildContext context) {
    if (canPop(context)) context.pop();
  }

  static bool canPop(BuildContext context) => context.canPop();

  static void pushNamed(BuildContext context, Routes googleDrive, {required Map<String, String> params}) {
    context.goNamed(googleDrive.name, pathParameters: params);
  }
}

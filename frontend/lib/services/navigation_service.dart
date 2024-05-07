import 'package:flutter/material.dart';
import 'package:frontend/utils/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._();

  factory NavigationService() {
    return _instance;
  }

  NavigationService._();

  void navigateTo(BuildContext context, Routes route, {Map<String, String>? params}) {
    context.goNamed(route.name, pathParameters: {if (params != null) ...params});
  }

  void goBack(BuildContext context) {
    if (context.canPop()) context.pop();
  }

}

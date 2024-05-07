import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/utils/routes/app_routes.dart';

class NavButton {
  final IconData myIcon;
  final Routes myRoute;
  final String name;

  IconData get icon => myIcon;
  Routes get route => myRoute;
  String get title => name;

  NavButton({required this.myIcon, required this.myRoute, required this.name});
}

List<NavButton> navButtonsData = [
  NavButton(
    myIcon: FontAwesomeIcons.house,
    myRoute: Routes.home,
    name: 'בית',
  ),
];
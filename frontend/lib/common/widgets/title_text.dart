import 'package:flutter/material.dart';
import 'package:frontend/utils/styles/fonts.dart';
import 'package:frontend/utils/helpers/functions.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.label,
    this.fontSize = 20,
    this.fontStyle = FontStyle.normal,
    this.decoration = TextDecoration.none,
    this.align = TextAlign.center,
    this.color = PRIMARY_COLOR,
  });

  final String label;
  final double fontSize;
  final FontStyle fontStyle;
  final TextDecoration decoration;
  final TextAlign align;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: align,
      label,
      style: headlineTextStyle.copyWith(
        color: Helpers.isDarkMode ? Colors.white : color,
        fontSize: fontSize,
        fontStyle: fontStyle,
        decoration: decoration,
        fontFamily: SANS_BLACK_FONT,
      ),
    );
  }
}

//secondary title text
class SecondaryText extends StatelessWidget {
  const SecondaryText({
    super.key,
    required this.label,
    this.fontSize = 20,
    this.fontStyle = FontStyle.normal,
    this.decoration = TextDecoration.none,
    this.align = TextAlign.right,
  });

  final String label;
  final double fontSize;
  final FontStyle fontStyle;
  final TextDecoration decoration;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: align,
      label,
      style: headlineSecondaryTextStyle.copyWith(
        fontSize: fontSize,
        color: Helpers.isDarkMode ? Colors.white : PRIMARY_COLOR,
      ),
    );
  }
}

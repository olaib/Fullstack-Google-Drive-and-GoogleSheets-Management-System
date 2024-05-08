import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/three_dimensional_text_widget.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class AppNameAnimatedText extends StatelessWidget {
  const AppNameAnimatedText({
    super.key,
    this.label = APP_NAME,
    this.fontSize = 30,
    this.duration = 5,
    required this.color,
    required this.baseColor,
    required this.highlightColor,
  });
  final double fontSize;
  final String label;
  final Color color;
  final int duration;
  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: Duration(seconds: duration),
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(children: [
        ThreeDText(
          label,
          fontSize: fontSize,
          color: color,
        )
      ]),
    );
  }
}

import 'package:flutter/material.dart';

class ThreeDText extends StatelessWidget {
  const ThreeDText(this.text, {super.key, this.fontSize = 30, this.color=Colors.black});
  final String text;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(0.01) // rotate around x-axis
        ..rotateY(0.01), // rotate around y-axis
      alignment: FractionalOffset.center,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: color),
      ),
    );
  }
}

class ThreeDimensionalTitle extends StatelessWidget {
  const ThreeDimensionalTitle(this.text, {super.key, this.fontSize = 30, this.color=Colors.black});
  final String text;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(0.01) // rotate around x-axis
        ..rotateY(0.01), // rotate around y-axis
      alignment: FractionalOffset.center,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: color),
      ),
    );
  }
}

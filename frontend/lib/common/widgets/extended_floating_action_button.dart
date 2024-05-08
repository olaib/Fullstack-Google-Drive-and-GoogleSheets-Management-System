import 'dart:math';

import 'package:flutter/material.dart';

class CustomExtendedFloatingActionButton extends StatelessWidget {
  const CustomExtendedFloatingActionButton(
      {super.key,
      required this.onPressed,
      required this.label,
      required this.tag,
      this.icon});

  final void Function() onPressed;
  final Widget label;
  final String tag;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        height: 45,
        child: FloatingActionButton.extended(
          hoverColor: Colors.blue,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          heroTag: tag + Random().nextInt(100).toString(),
          onPressed: onPressed,
          label: label,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          icon: (icon != null) ? Icon(icon) : null,
        ));
  }
}

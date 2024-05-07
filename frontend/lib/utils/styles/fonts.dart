// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
const String SANS_BLACK_FONT = 'SansBlack';

const Color PRIMARY_COLOR = Color(0xFF1451AD);

const TextStyle headlineTextStyle = TextStyle(
  fontFamily: SANS_BLACK_FONT,
  height: 1.2,
  color: PRIMARY_COLOR,
  fontSize: 44,
  fontWeight: FontWeight.bold,
);

//second text headline
const TextStyle headlineSecondaryTextStyle = TextStyle(
  fontFamily: SANS_BLACK_FONT,
  height: 1.2,
  color: PRIMARY_COLOR,
  fontSize: 28,
  fontWeight: FontWeight.bold,
);

//body text style
const TextStyle bodyTextStyle = TextStyle(
  fontFamily: SANS_BLACK_FONT,
  height: 1.2,
  color: PRIMARY_COLOR,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

//body link text style
TextStyle bodyLinkTextStyle = bodyTextStyle.copyWith(
  color: PRIMARY_COLOR,
);

//button text style
const TextStyle buttonTextStyle = TextStyle(
  fontFamily: SANS_BLACK_FONT,
  height: 1.2,
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);


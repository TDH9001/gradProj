import 'dart:ui';

import 'package:flutter/material.dart';

abstract class DarkThemeColors {
  static const Color primary = Color(0xFF323232);
  static const Color secondary = Color(0xFF4A739F);
  static const Color background = Color(0xFF1C1C1C);
  static const Color textcolor = Color(0xffE0E0E0);
  static const  buttonBackgroundColor = Color(0xff2E5077);
  static const  iconColor = Color(0xffA3BFE0);
  static const  arrowColor = Colors.white70;
  static const backgroundImage = Colors.white70;
  static const buttonColor = Color(0xFF2E5077);
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFF1C1C1C),
      Color(0xFF2E3B55),
      secondary,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

}
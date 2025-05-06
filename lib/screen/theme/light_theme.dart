import 'dart:ui';

import 'package:flutter/material.dart';
abstract class LightTheme{
  static const primary = Color(0xff2E5077);
  static const secondary = Color(0xff769BC6);
  static const background = Color(0xffffffff);
  static const textcolor = Color(0xff000000);
  static const backimg = Color(0xFF2E3B55);
  static const backgroundImage = Colors.white;
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
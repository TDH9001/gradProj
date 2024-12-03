import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

const Color accent = Color(0x7AB2D3);
const Color backGround = Colors.white;
const Color textAndAccent = Colors.black;

void printSnackBar(BuildContext context, String S) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(S)),
  );
}

//  MediaQuery.of(context).size.height;

class TextStyles {
  static TextStyle text = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static TextStyle subtext = TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
}

import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  TextHeader(
      {super.key,
      required this.height,
      required this.largeText,
      required this.littleText});
  double height;
  String largeText;
  String littleText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height, //* 0.24,
      child: Center(
        child: ListView(
          children: [
            Text(
              largeText,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            Text(
              littleText,
              style: const TextStyle(fontSize: 18, color: Color(0xFF9CA3AF)),
            )
          ],
        ),
      ),
    );
  }
}

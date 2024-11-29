import 'package:flutter/material.dart';
import 'package:grad_proj/screen/resetpassword_screen.dart';

class Navigatortextbutton extends StatelessWidget {
  Navigatortextbutton({super.key, required this.text, required this.location});
  final String text;
  final String location;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, location);
        },
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.underline,
              decorationThickness: 2,
              color: Colors.black),
        ));
  }
}

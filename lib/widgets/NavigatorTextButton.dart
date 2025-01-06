import 'package:flutter/material.dart';
import '../services/navigation_Service.dart';

class Navigatortextbutton extends StatelessWidget {
  Navigatortextbutton({super.key, required this.text, required this.location});
  final String text;
  final String location;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (location != "pop") {
            navigationService.instance.navigateTo(location);
          } else {
            navigationService.instance.goBack();
          }
          // Navigator.pushNamed(context, location);
        },
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xff7AB2D3),
              decorationThickness: 2,
              color: Color(0xff7AB2D3)),
        ));
  }
}

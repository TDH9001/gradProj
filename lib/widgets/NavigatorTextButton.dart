import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/navigation_Service.dart';

class Navigatortextbutton extends StatelessWidget {
  Navigatortextbutton({super.key, required this.text, required this.location});
  final String text;
  final String location;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
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
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.underline,
              decorationColor:  isDarkMode ? Color(0xff769BC6) : Color(0xff2E5077),
              decorationThickness: 2,
              color: isDarkMode ? Color(0xff769BC6) : Color(0xff2E5077)),
        ));
  }
}

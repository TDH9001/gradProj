import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../screen/theme/dark_theme_colors.dart';
import '../screen/theme/light_theme.dart';

class CustomScibutton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomScibutton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:isDarkMode ? DarkThemeColors.buttonColor : LightTheme.primary,
          foregroundColor: Colors.white,
          side: BorderSide(color: Color(0xffA3BFE0)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/theme/dark_theme_colors.dart';
import '../features/theme/light_theme.dart';
import '../features/theme/theme_provider.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({super.key, required this.buttontext, required this.func});
  final String buttontext;
  VoidCallback func;
  //PrimaryButton({required this.buttontext});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return SizedBox(
    height: 50,
     width: 300,
     child:  ElevatedButton(
      onPressed: func,
      style: ElevatedButton.styleFrom(
        backgroundColor:isDarkMode ? DarkThemeColors.buttonColor :   LightTheme.primary,
        //0xFF2E5077
        // padding: const EdgeInsets.symmetric(vertical: 16),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(8),
        // ),
      ),
      child: Text(
      buttontext,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
     ),
    );
  }
}

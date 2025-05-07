import 'package:flutter/material.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class CustomContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  const CustomContainer({super.key, this.width=300, this.height=600, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? DarkThemeColors.primary :Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isDarkMode ? DarkThemeColors.primary : Colors.grey, width: 1.5),
        ),
        child: child
    );;
  }
}

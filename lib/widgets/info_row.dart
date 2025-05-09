import 'package:flutter/material.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDarkMode;
  final IconData? icon;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    required this.isDarkMode,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 18,
              color: isDarkMode
                  ? DarkThemeColors.secondary
                  : LightTheme.primary,
            ),
          if (icon != null) const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDarkMode
                      ? DarkThemeColors.textcolor
                      : LightTheme.textcolor)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(value,
                  style: TextStyle(
                      fontSize: 15,
                      color: isDarkMode
                          ? DarkThemeColors.textcolor
                          : LightTheme.textcolor))),
        ],
      ),
    );
  }
}
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';

class AddCourseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isDarkMode;

  const AddCourseButton({
    Key? key,
    required this.onPressed,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: Text(tr('academicCareer.addNewCourseButton')),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDarkMode ? DarkThemeColors.secondary : LightTheme.secondary,
          foregroundColor:
              isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

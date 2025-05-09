import 'package:flutter/material.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';
import '../models/Semester_logs_models/semester_model.dart';

class SemesterSelector extends StatelessWidget {
  final int selectedIndex;
  final List<SemesterModel> semesters;
  final bool isDarkMode;
  final ValueChanged<int> onChanged;

  const SemesterSelector({
    Key? key,
    required this.selectedIndex,
    required this.semesters,
    required this.isDarkMode,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: DropdownButton<int>(
        value: selectedIndex,
        dropdownColor:
            isDarkMode ? DarkThemeColors.primary : LightTheme.background,
        iconEnabledColor:
            isDarkMode ? DarkThemeColors.secondary : LightTheme.primary,
        style: TextStyle(
          color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
          fontWeight: FontWeight.bold,
        ),
        items: List.generate(
          semesters.length,
          (index) {
            final sem = semesters[index];
            return DropdownMenuItem<int>(
              value: index,
              child: Text(
                "${sem.semesterName} ${sem.semesterYear}",
                style: TextStyle(
                  color: isDarkMode
                      ? DarkThemeColors.textcolor
                      : LightTheme.textcolor,
                ),
              ),
            );
          },
        ),
        onChanged: (int? newIndex) {
          if (newIndex != null) {
            onChanged(newIndex);
          }
        },
      ),
    );
  }
}

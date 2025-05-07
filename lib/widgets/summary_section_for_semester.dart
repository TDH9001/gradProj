import 'package:flutter/material.dart';
import '../models/Semester_logs_models/semester_model.dart';
import '../theme/dark_theme_colors.dart';
import '../theme/light_theme.dart';

class SummarySectionForSemester extends StatelessWidget {
  final SemesterModel semester;
  final bool isDarkMode;

  const SummarySectionForSemester({
    Key? key,
    required this.semester,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalCredits = semester.courses.fold(0, (sum, c) => sum + c.creditHours);
    double gpa = semester.courses.isNotEmpty
        ? semester.courses.fold(0.0, (sum, c) => sum + c.grade) / semester.courses.length
        : 0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? DarkThemeColors.secondary.withOpacity(0.10)
            : LightTheme.secondary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Credits: $totalCredits",
            style: TextStyle(
              color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Semester GPA: ${gpa.toStringAsFixed(2)}",
            style: TextStyle(
              color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
            ),
          ),
        ],
      ),
    );
  }
}
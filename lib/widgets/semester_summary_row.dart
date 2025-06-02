import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';
import '../models/Semester_logs_models/semester_model.dart';

class SemesterSummaryRow extends StatelessWidget {
  final SemesterModel semester;
  final bool isDarkMode;

  const SemesterSummaryRow({
    Key? key,
    required this.semester,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalCreditHours = semester.courses.fold(0, (sum, c) => sum + c.creditHours);
    double gpa = semester.semmesterGpa;
    String gradeLetter = semester.semesterGrade.toString().split('.').last;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? DarkThemeColors.secondary.withOpacity(0.10)
            : LightTheme.secondary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        tr(
          "academicCareer.semesterSummaryText",
          namedArgs: {
            'hours': totalCreditHours.toStringAsFixed(1),
            'gpa': gpa.toStringAsFixed(2),
            'letter': gradeLetter,
          },
        ),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isDarkMode ? DarkThemeColors.secondary : LightTheme.secondary,
        ),
      ),
    );
  }
}
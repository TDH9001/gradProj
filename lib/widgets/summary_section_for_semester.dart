import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../models/Semester_logs_models/semester_model.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';

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
            tr("academicCareer.summaryTotalCredits", namedArgs: {'credits': totalCredits.toStringAsFixed(0)}),
            style: TextStyle(
              color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tr("academicCareer.summarySemesterGpa", namedArgs: {'gpa': semester.semmesterGpa.toStringAsFixed(2)}),
            style: TextStyle(
              color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
            ),
          ),
        ],
      ),
    );
  }
}
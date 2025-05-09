import 'package:flutter/material.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';
import '../models/Semester_logs_models/semester_model.dart';

class SemesterSection extends StatelessWidget {
  final SemesterModel semester;
  final bool isDarkMode;
  final Widget coursesTable;
  final Widget summaryRow;

  const SemesterSection({
    Key? key,
    required this.semester,
    required this.isDarkMode,
    required this.coursesTable,
    required this.summaryRow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? DarkThemeColors.secondary.withValues(alpha: 0.15)
                : LightTheme.secondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            "المستوى: ${semester.level}  |  برنامج الرياضيات  |  ${semester.semesterYear}  |  فصل ${semester.semesterName}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color:
                  isDarkMode ? DarkThemeColors.secondary : LightTheme.secondary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        coursesTable,
        const SizedBox(height: 6),
        summaryRow,
      ],
    );
  }
}

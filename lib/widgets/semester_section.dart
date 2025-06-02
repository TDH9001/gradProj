import 'package:easy_localization/easy_localization.dart';
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
    // Prepare potentially localized parts
    String localizedLevel = tr('academicCareer.labelLevel');
    // Assuming semester.level is already localized if it's like "First"/"الأول"
    // If semester.level is a number like 1, 2, 3, it doesn't need localization itself.
    String levelDisplay = semester.level.toString(); 

    String localizedProgramName = tr('academicCareer.programNameMath');
    String localizedSemesterLabel = tr('academicCareer.labelSemester');
    
    // Assuming semester.semesterName and semester.semesterYear are already correctly formatted/localized if needed
    String semesterNameDisplay = semester.semesterName;
    String semesterYearDisplay = semester.semesterYear;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? DarkThemeColors.secondary.withOpacity(0.15)
                : LightTheme.secondary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            "$localizedLevel $levelDisplay  |  $localizedProgramName  |  $semesterYearDisplay  |  $localizedSemesterLabel $semesterNameDisplay",
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

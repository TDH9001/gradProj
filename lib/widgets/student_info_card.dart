import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Semester_logs_models/academic_career.dart';
import 'package:grad_proj/utils/grade_utils.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';
import 'info_row.dart';

class StudentInfoCard extends StatelessWidget {
  final AcademicCareer career;
  final bool isDarkMode;
  final String studentName;
  final String studentId;
  final String nationality;

  const StudentInfoCard({
    Key? key,
    required this.career,
    required this.isDarkMode,
    this.studentName = "",
    this.studentId = "",
    this.nationality = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalCreditHours = career.semesters.fold(
        0, (sum, semester) => sum + semester.courses.fold(0, (sum, course) => sum + course.creditHours));

    String displayName = studentName.isNotEmpty ? studentName : tr("academicCareer.defaultValueUndefined");
    String displayId = studentId.isNotEmpty ? studentId : tr("academicCareer.defaultValueUndefined");
    String displayNationality = nationality.isNotEmpty ? nationality : tr("academicCareer.defaultValueUndefined");

    return Card(
      color: isDarkMode ? DarkThemeColors.secondary : LightTheme.secondary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("academicCareer.studentInfoCardTitle"),
                  style: TextStyle(
                    color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Icon(
                  Icons.school,
                  color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
                  size: 24,
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            InfoRow(
              label: tr("academicCareer.labelName"),
              value: displayName,
              isDarkMode: isDarkMode,
              icon: Icons.person,
            ),
            InfoRow(
              label: tr("academicCareer.labelNationalId"),
              value: displayId,
              isDarkMode: isDarkMode,
              icon: Icons.badge,
            ),
            InfoRow(
              label: tr("academicCareer.labelNationality"),
              value: displayNationality,
              isDarkMode: isDarkMode,
              icon: Icons.public,
            ),
            InfoRow(
              label: tr("academicCareer.labelSeatNumber"),
              value: career.seatNumber.isNotEmpty ? career.seatNumber : tr("academicCareer.defaultValueUndefined"),
              isDarkMode: isDarkMode,
              icon: Icons.numbers,
            ),
            InfoRow(
              label: tr("academicCareer.labelPassedHours"),
              value: "${career.succesHours}",
              isDarkMode: isDarkMode,
              icon: Icons.access_time_filled,
            ),
            InfoRow(
              label: tr("academicCareer.labelTotalCreditHours"),
              value: "$totalCreditHours",
              isDarkMode: isDarkMode,
              icon: Icons.credit_card,
            ),
            InfoRow(
              label: tr("academicCareer.labelCumulativeGpa"),
              value: "${career.gpa.toStringAsFixed(2)}",
              isDarkMode: isDarkMode,
              icon: Icons.grade,
            ),
            InfoRow(
              label: tr("academicCareer.labelSemesterCount"),
              value: "${career.semesters.length}",
              isDarkMode: isDarkMode,
              icon: Icons.calendar_month,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? DarkThemeColors.primary.withOpacity(0.2)
                    : LightTheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tr(GradeUtils.getStudentStatus(career.gpa)),
                style: TextStyle(
                  color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
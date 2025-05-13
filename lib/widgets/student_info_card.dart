import 'package:flutter/material.dart';
import 'package:grad_proj/models/Semester_logs_models/academic_career.dart';
import 'package:grad_proj/utils/grade_utils.dart';
import '../theme/dark_theme_colors.dart';
import '../theme/light_theme.dart';
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
    this.studentName = "غير محدد",
    this.studentId = "غير محدد",
    this.nationality = "غير محدد",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalCreditHours = career.semesters.fold(
        0, (sum, semester) => sum + semester.courses.fold(0, (sum, course) => sum + course.creditHours));

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
                  "معلومات الطالب",
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
              label: "الاسم:",
              value: studentName,
              isDarkMode: isDarkMode,
              icon: Icons.person,
            ),
            InfoRow(
              label: "الرقم القومي:",
              value: studentId,
              isDarkMode: isDarkMode,
              icon: Icons.badge,
            ),
            InfoRow(
              label: "الجنسية:",
              value: nationality,
              isDarkMode: isDarkMode,
              icon: Icons.public,
            ),
            InfoRow(
              label: "رقم المقعد:",
              value: career.seatNumber,
              isDarkMode: isDarkMode,
              icon: Icons.numbers,
            ),
            InfoRow(
              label: "الساعات المجتازة:",
              value: "${career.succesHours}",
              isDarkMode: isDarkMode,
              icon: Icons.access_time_filled,
            ),
            InfoRow(
              label: "إجمالي الساعات المعتمدة:",
              value: "$totalCreditHours",
              isDarkMode: isDarkMode,
              icon: Icons.credit_card,
            ),
            InfoRow(
              label: "المعدل التراكمي:",
              value: "${career.gpa.toStringAsFixed(2)}",
              isDarkMode: isDarkMode,
              icon: Icons.grade,
            ),
            InfoRow(
              label: "عدد الفصول الدراسية:",
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
                    ? DarkThemeColors.primary.withValues(alpha: 0.2) 
                    : LightTheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                GradeUtils.getStudentStatus(career.gpa),
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
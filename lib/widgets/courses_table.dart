import 'package:flutter/material.dart';
import '../theme/dark_theme_colors.dart';
import '../theme/light_theme.dart';
import '../models/Semester_logs_models/course_model.dart';
import '../models/Semester_logs_models/semester_model.dart';

class CoursesTable extends StatelessWidget {
  final List<CourseModel> courses;
  final bool isDarkMode;
  final SemesterModel semester;
  final void Function(int index, CourseModel course) onEdit;
  final void Function(int index) onDelete;

  const CoursesTable({
    Key? key,
    required this.courses,
    required this.isDarkMode,
    required this.semester,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(
            isDarkMode
                ? DarkThemeColors.secondary.withValues(alpha: 0.2)
                : LightTheme.secondary.withValues(alpha: 0.2)),
        dataRowColor: WidgetStateProperty.all(
            isDarkMode
                ? DarkThemeColors.background
                : LightTheme.background),
        columnSpacing: 18,
        columns: [
          DataColumn(label: Text("Grade", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
          DataColumn(label: Text("Credit Hours", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
          DataColumn(label: Text("Course Score", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
          DataColumn(label: Text("Grade Letter", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
          DataColumn(label: Text("Course Name", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
          DataColumn(label: Text("Course Code", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
          DataColumn(label: Text("Actions", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
        ],
        rows: List.generate(courses.length, (index) {
          final course = courses[index];
          return DataRow(
            cells: [
              DataCell(Text(
                  course.grade.toStringAsFixed(3),
                  style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
              DataCell(Text(course.creditHours.toStringAsFixed(2), style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
              DataCell(Text(course.courseScore.toStringAsFixed(2), style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
              DataCell(Text(course.gradeLetter != null ? course.gradeLetter.toString().split('.').last : "", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
              DataCell(Text(course.courseName, style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
              DataCell(Text(course.courseCode, style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: isDarkMode ? Colors.orange : Colors.blue),
                    tooltip: 'Edit',
                    onPressed: () => onEdit(index, course),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: () => onDelete(index),
                  ),
                ],
              )),
            ],
          );
        }),
      ),
    );
  }
}
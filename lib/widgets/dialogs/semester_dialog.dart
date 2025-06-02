import 'package:flutter/material.dart';
import 'package:grad_proj/models/Semester_logs_models/course_model.dart';
import 'package:grad_proj/models/Semester_logs_models/semester_model.dart';
import 'package:grad_proj/providers/theme_provider.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';
import 'package:grad_proj/widgets/add_course_button.dart';
import 'package:provider/provider.dart';
import 'course_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

class SemesterDialog extends StatefulWidget {
  final Function(SemesterModel) onAddSemester;

  const SemesterDialog({
    Key? key,
    required this.onAddSemester,
  }) : super(key: key);

  @override
  State<SemesterDialog> createState() => _SemesterDialogState();
}

class _SemesterDialogState extends State<SemesterDialog> {
  final TextEditingController _semesterYearController = TextEditingController();
  final TextEditingController _semesterNameController = TextEditingController();
  final TextEditingController _semesterNumberController = TextEditingController();
  List<CourseModel> newCourses = [];

  @override
  void dispose() {
    _semesterYearController.dispose();
    _semesterNameController.dispose();
    _semesterNumberController.dispose();
    super.dispose();
  }

  void _addCourseToList(CourseModel course) {
    setState(() {
      newCourses.add(course);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return AlertDialog(
      backgroundColor: isDarkMode ? DarkThemeColors.background : LightTheme.background,
      title: Text(tr('academicCareer.semesterDialogTitleAdd'), style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(_semesterYearController, tr('academicCareer.semesterDialogLabelSemesterYear'), isDarkMode),
            _buildTextField(_semesterNameController, tr('academicCareer.semesterDialogLabelSemesterName'), isDarkMode),
            _buildTextField(_semesterNumberController, tr('academicCareer.semesterDialogLabelSemesterNumber'), isDarkMode, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            AddCourseButton(
              onPressed: () async {
                final result = await showDialog<CourseModel>(
                  context: context,
                  builder: (context) => CourseDialog(
                    isDarkMode: isDarkMode,
                    isNewCourse: true,
                  ),
                );
                if (result != null) {
                  _addCourseToList(result);
                }
              },
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 8),
            Text(tr('academicCareer.semesterDialogCoursesCount', namedArgs: {'count': newCourses.length.toString()}), style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor)),
            if (newCourses.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildCoursesList(isDarkMode),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(tr('academicCareer.courseDialogButtonCancel'), style: TextStyle(color: isDarkMode ? DarkThemeColors.secondary : LightTheme.secondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? DarkThemeColors.primary : LightTheme.primary,
            foregroundColor: isDarkMode ? DarkThemeColors.buttonTextColor : LightTheme.buttonTextColor,
          ),
          onPressed: () {
            if (_semesterYearController.text.isNotEmpty &&
                _semesterNameController.text.isNotEmpty &&
                _semesterNumberController.text.isNotEmpty &&
                newCourses.isNotEmpty) {
              final semester = SemesterModel(
                List<CourseModel>.from(newCourses),
                _semesterYearController.text,
                _semesterNameController.text,
                int.tryParse(_semesterNumberController.text) ?? 1,
              );
              widget.onAddSemester(semester);
              Navigator.of(context).pop();
            }
          },
          child: Text(tr('academicCareer.semesterDialogButtonAddSemester')),
        ),
      ],
    );
  }

  Widget _buildCoursesList(bool isDarkMode) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode ? DarkThemeColors.secondary : LightTheme.secondary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        itemCount: newCourses.length,
        itemBuilder: (context, index) {
          final course = newCourses[index];
          return ListTile(
            dense: true,
            title: Text(
              course.courseName,
              style: TextStyle(
                color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
              ),
            ),
            subtitle: Text(
              tr('academicCareer.semesterDialogCourseListItem', namedArgs: {
                'code': course.courseCode,
                'hours': course.creditHours.toString(),
                'grade': course.grade.toStringAsFixed(3)
              }),
              style: TextStyle(
                color: isDarkMode 
                    ? DarkThemeColors.textcolor.withOpacity(0.7) 
                    : LightTheme.textcolor.withOpacity(0.7),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  newCourses.removeAt(index);
                });
              },
              color: isDarkMode ? DarkThemeColors.danger : Colors.redAccent,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, bool isDarkMode, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor.withOpacity(0.7) : LightTheme.textcolor.withOpacity(0.7)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? DarkThemeColors.secondary : LightTheme.secondary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? DarkThemeColors.primary : LightTheme.primary),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
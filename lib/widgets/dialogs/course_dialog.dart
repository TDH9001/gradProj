import 'package:flutter/material.dart';
import 'package:grad_proj/models/Semester_logs_models/course_model.dart';
import 'package:grad_proj/utils/grade_utils.dart';
import 'package:grad_proj/widgets/add_course_button.dart';

class CourseDialog extends StatefulWidget {
  final bool isDarkMode;
  final CourseModel? existingCourse;
  final bool isNewCourse;

  const CourseDialog({
    Key? key,
    required this.isDarkMode,
    this.existingCourse,
    this.isNewCourse = false,
  }) : super(key: key);

  @override
  State<CourseDialog> createState() => _CourseDialogState();
}

class _CourseDialogState extends State<CourseDialog> {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _creditHoursController = TextEditingController();
  final TextEditingController _courseScoreController = TextEditingController();
  final TextEditingController _gradeLetterController = TextEditingController();

  final GradeUtils _gradeUtils = GradeUtils();

  @override
  void initState() {
    super.initState();
    if (widget.existingCourse != null) {
      _courseNameController.text = widget.existingCourse!.courseName;
      _courseCodeController.text = widget.existingCourse!.courseCode;
      _gradeController.text = widget.existingCourse!.grade.toString();
      _creditHoursController.text = widget.existingCourse!.creditHours.toString();
      _courseScoreController.text = widget.existingCourse!.courseScore.toString();
      _gradeLetterController.text = widget.existingCourse!.gradeLetter?.toString().split('.').last ?? "";
    }
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _gradeController.dispose();
    _creditHoursController.dispose();
    _courseScoreController.dispose();
    _gradeLetterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String dialogTitle = widget.existingCourse != null ? 'Edit Course' : 'Add Course';
    
    return AlertDialog(
      title: Text(dialogTitle),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _courseNameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            TextField(
              controller: _courseCodeController,
              decoration: const InputDecoration(labelText: 'Course Code'),
            ),
            TextField(
              controller: _courseScoreController,
              decoration: const InputDecoration(labelText: 'Course Score'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  double score = double.tryParse(value) ?? 0;
                  var result = GradeUtils.calculateGradeAndLetterFromScore(score);
                  _gradeController.text = result['grade'].toString();
                  _gradeLetterController.text = result['gradeLetter'].toString().split('.').last;
                });
              },
            ),
            TextField(
              controller: _gradeController,
              decoration: const InputDecoration(labelText: 'Grade'),
              keyboardType: TextInputType.number,
              enabled: false,
            ),
            TextField(
              controller: _creditHoursController,
              decoration: const InputDecoration(labelText: 'Credit Hours'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _gradeLetterController,
              decoration: const InputDecoration(labelText: 'Grade Letter'),
              enabled: false,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        AddCourseButton(
          onPressed: () {
            double score = double.tryParse(_courseScoreController.text) ?? 0;
            var result = GradeUtils.calculateGradeAndLetterFromScore(score);
            
            final courseModel = CourseModel(
              courseCode: _courseCodeController.text,
              courseName: _courseNameController.text,
              grade: result['grade'],
              creditHours: int.tryParse(_creditHoursController.text) ?? 0,
              courseScore: score,
              gradeLetter: result['gradeLetter'],
            );
            
            Navigator.of(context).pop(courseModel);
          },
          isDarkMode: widget.isDarkMode,
        ),
      ],
    );
  }
}
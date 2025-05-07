// import 'package:flutter/material.dart';
// import 'package:grad_proj/constants/constatns.dart';

// import 'package:grad_proj/models/Semester_logs_models/course_model.dart';
// import 'package:grad_proj/providers/theme_provider.dart';
// import 'package:grad_proj/utils/grade_utils.dart';
// import 'package:grad_proj/widgets/add_course_button.dart';
// import 'package:provider/provider.dart';

// class CourseDialog extends StatefulWidget {
//   final CourseModel? course; // null for add, non-null for edit
//   final Function(CourseModel) onSave;

//   const CourseDialog({
//     Key? key,
//     this.course,
//     required this.onSave,
//   }) : super(key: key);

//   @override
//   State<CourseDialog> createState() => _CourseDialogState();
// }

// class _CourseDialogState extends State<CourseDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _courseNameController = TextEditingController();
//   final TextEditingController _courseCodeController = TextEditingController();
//   final TextEditingController _gradeController = TextEditingController();
//   final TextEditingController _creditHoursController = TextEditingController();
//   final TextEditingController _courseScoreController = TextEditingController();
//   final TextEditingController _gradeLetterController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.course != null) {
//       // Edit mode
//       _courseNameController.text = widget.course!.courseName;
//       _courseCodeController.text = widget.course!.courseCode;
//       _gradeController.text = widget.course!.grade.toString();
//       _creditHoursController.text = widget.course!.creditHours.toString();
//       _courseScoreController.text = widget.course!.courseScore.toString();
//       _gradeLetterController.text = widget.course!.gradeLetter?.toString().split('.').last ?? "";
//     }
//   }

//   @override
//   void dispose() {
//     _courseNameController.dispose();
//     _courseCodeController.dispose();
//     _gradeController.dispose();
//     _creditHoursController.dispose();
//     _courseScoreController.dispose();
//     _gradeLetterController.dispose();
//     super.dispose();
//   }

//   void _updateGradeValues(String value) {
//     double score = double.tryParse(value) ?? 0;
//     var result = GradeUtils.calculateGradeAndLetterFromScore(score);
//     setState(() {
//       _gradeController.text = result['grade'].toString();
//       _gradeLetterController.text = result['gradeLetter'].toString().split('.').last;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
//     final isDarkMode = themeProvider.isDarkMode;
//     final isEditMode = widget.course != null;

//     return AlertDialog(
//       title: Text(isEditMode ? AppStrings.editCourse : AppStrings.addCourse),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _courseNameController,
//                 decoration: const InputDecoration(labelText: AppStrings.courseName),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter course name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _courseCodeController,
//                 decoration: const InputDecoration(labelText: AppStrings.courseCode),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter course code';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _courseScoreController,
//                 decoration: const InputDecoration(labelText: AppStrings.courseScore),
//                 keyboardType: TextInputType.number,
//                 onChanged: _updateGradeValues,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter course score';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _gradeController,
//                 decoration: const InputDecoration(labelText: AppStrings.grade),
//                 enabled: false,
//               ),
//               TextFormField(
//                 controller: _creditHoursController,
//                 decoration: const InputDecoration(labelText: AppStrings.creditHours),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter credit hours';
//                   }
//                   if (int.tryParse(value) == null) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _gradeLetterController,
//                 decoration: const InputDecoration(labelText: AppStrings.gradeLetter),
//                 enabled: false,
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text(AppStrings.cancel),
//         ),
//         AddCourseButton(
//           onPressed: () {
//             if (_formKey.currentState!.validate()) {
//               double score = double.tryParse(_courseScoreController.text) ?? 0;
//               var result = GradeUtils.calculateGradeAndLetterFromScore(score);
              
//               final courseModel = CourseModel(
//                 courseCode: _courseCodeController.text,
//                 courseName: _courseNameController.text,
//                 grade: result['grade'],
//                 creditHours: int.tryParse(_creditHoursController.text) ?? 0,
//                 courseScore: score,
//                 gradeLetter: result['gradeLetter'],
//               );
              
//               widget.onSave(courseModel);
//               Navigator.of(context).pop();
//             }
//           },
//           isDarkMode: isDarkMode,
//         ),
//       ],
//     );
//   }

//   static Future<void> show({
//     required BuildContext context,
//     CourseModel? course,
//     required Function(CourseModel) onSave,
//   }) async {
//     return showDialog(
//       context: context,
//       builder: (context) => CourseDialog(
//         course: course,
//         onSave: onSave,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:grad_proj/constants/constatns.dart';

import 'package:grad_proj/models/Semester_logs_models/course_model.dart';
import 'package:grad_proj/providers/theme_provider.dart';
import 'package:grad_proj/utils/grade_utils.dart';
import 'package:grad_proj/widgets/add_course_button.dart';
import 'package:provider/provider.dart';


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
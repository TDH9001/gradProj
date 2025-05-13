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

  bool _isPassFailCourse = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingCourse != null) {
      _courseNameController.text = widget.existingCourse!.courseName;
      _courseCodeController.text = widget.existingCourse!.courseCode;
      _creditHoursController.text = widget.existingCourse!.creditHours.toString();
      _courseScoreController.text = widget.existingCourse!.courseScore.toString();
      

      if (widget.existingCourse!.creditHours == 0 && 
          (widget.existingCourse!.gradeLetter == Grades.P || widget.existingCourse!.gradeLetter == Grades.F) &&
          widget.existingCourse!.grade == 0.0) {
        _isPassFailCourse = true;
      }
      _updateGradeAndLetterFields(); 

      _courseScoreController.addListener(_updateGradeAndLetterFields);
      _creditHoursController.addListener(_updateGradeAndLetterFields);

    } else {
      _courseScoreController.addListener(_updateGradeAndLetterFields);
      _creditHoursController.addListener(_updateGradeAndLetterFields);
    }
  }

  void _updateGradeAndLetterFields() {
    double rawScore = double.tryParse(_courseScoreController.text) ?? 0;
    int creditHours = int.tryParse(_creditHoursController.text) ?? 0;

    if (_isPassFailCourse) {
      _gradeController.text = "0.000";

      _gradeLetterController.text = (rawScore >= 30.0) ? "P" : "F"; 

    } else {
      double maxScore = 0;
      if (creditHours <= 0) {
        _gradeController.text = "-";
        _gradeLetterController.text = "-";
        if (mounted) setState(() {});
        return;
      }
      if (creditHours == 1) maxScore = 50;
      else if (creditHours == 2) maxScore = 100;
      else if (creditHours == 3) maxScore = 150;
      else if (creditHours == 4) maxScore = 200; 
      else if (creditHours == 5) maxScore = 250; 
      else if (creditHours == 6) maxScore = 300; 
      else { maxScore = creditHours * 50.0; }

      if (maxScore == 0) {
        _gradeController.text = "-";
        _gradeLetterController.text = "-";
        if (mounted) setState(() {});
        return;
      }
      double percentageScore = (rawScore / maxScore) * 100.0;
      percentageScore = percentageScore.clamp(0.0, 100.0);
      var result = GradeUtils.calculateGradeAndLetterFromScore(percentageScore);
      _gradeController.text = (result['grade'] as double).toStringAsFixed(3);
      _gradeLetterController.text = (result['gradeLetter'] as Grades).toString().split('.').last;
    }
    
    if (mounted) {
        setState(() {});
    }
  }
  @override
  void dispose() {
    _courseScoreController.removeListener(_updateGradeAndLetterFields);
    _creditHoursController.removeListener(_updateGradeAndLetterFields);
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
            CheckboxListTile(
              title: const Text("Pass/Fail Course (0 GPA Credits)"),
              value: _isPassFailCourse,
              onChanged: (bool? newValue) {
                setState(() {
                  _isPassFailCourse = newValue!;
                  _updateGradeAndLetterFields();
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            TextField(
              controller: _courseScoreController,
              decoration: const InputDecoration(labelText: 'Course Score'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
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
              onChanged: (value) {
              },
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
            print("CourseDialog: Add button pressed.");
            String courseName = _courseNameController.text;
            String courseCode = _courseCodeController.text;
            double rawCourseScore = double.tryParse(_courseScoreController.text) ?? 0;
            int actualEnteredCreditHours = int.tryParse(_creditHoursController.text) ?? 0;

            int gpaCreditHours;
            int academicCreditValue; 
            Grades? finalGradeLetterValue;
            double finalGradePointsValue;

            print("CourseDialog: Add button: _isPassFailCourse = $_isPassFailCourse");

            if (_isPassFailCourse) {
              gpaCreditHours = 0;
              academicCreditValue = actualEnteredCreditHours; 
              finalGradePointsValue = 0.0;
              finalGradeLetterValue = (rawCourseScore >= 30.0) ? Grades.P : Grades.F;
              print("CourseDialog: Pass/Fail. RawScore: $rawCourseScore, Letter: $finalGradeLetterValue, GPA Credits: $gpaCreditHours, Academic Credits: $academicCreditValue");
            } else {
              gpaCreditHours = actualEnteredCreditHours;
              academicCreditValue = actualEnteredCreditHours; 
              double maxScore = 0;
              if (gpaCreditHours == 1) maxScore = 50;
              else if (gpaCreditHours == 2) maxScore = 100;
              else if (gpaCreditHours == 3) maxScore = 150;
              else if (gpaCreditHours == 4) maxScore = 200;
              else if (gpaCreditHours == 5) maxScore = 250;
              else if (gpaCreditHours == 6) maxScore = 300;
              else { maxScore = gpaCreditHours * 50.0; }

              if (gpaCreditHours > 0 && maxScore > 0) {
                  double percentageScore = (rawCourseScore / maxScore) * 100.0;
                  percentageScore = percentageScore.clamp(0.0, 100.0);
                  var result = GradeUtils.calculateGradeAndLetterFromScore(percentageScore);
                  finalGradeLetterValue = result['gradeLetter'] as Grades?;
                  finalGradePointsValue = result['grade'] as double;
                  print("CourseDialog: Standard. Percentage: $percentageScore%, Points: $finalGradePointsValue, Letter: $finalGradeLetterValue, GPA Credits: $gpaCreditHours, Academic Credits: $academicCreditValue");
              } else {
                  print("CourseDialog: Standard but invalid credits/maxScore. Defaulting.");
                  finalGradeLetterValue = Grades.F; 
                  finalGradePointsValue = 0.0;
              }
            }
            
            final courseModel = CourseModel(
              courseCode: courseCode,
              courseName: courseName,
              grade: finalGradePointsValue, 
              creditHours: gpaCreditHours,
              courseScore: rawCourseScore, 
              gradeLetter: finalGradeLetterValue,
              academicCredits: academicCreditValue,
            );
            
            print("CourseDialog: Created CourseModel: ${courseModel.toJson()}");
            try {
              print("CourseDialog: Attempting to pop with CourseModel...");
              Navigator.of(context).pop(courseModel);
              print("CourseDialog: Successfully popped with CourseModel.");
            } catch (e, s) {
              print("CourseDialog: ERROR popping with CourseModel: $e");
              print("CourseDialog: Stacktrace: $s");
              Navigator.of(context).pop();
            }
          },
          isDarkMode: widget.isDarkMode,
        ),
      ],
    );
  }
}
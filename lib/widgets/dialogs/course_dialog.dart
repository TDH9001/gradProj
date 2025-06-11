import 'package:flutter/material.dart';
import 'package:grad_proj/models/Semester_logs_models/course_model.dart';
import 'package:grad_proj/utils/grade_utils.dart';
import 'package:grad_proj/widgets/add_course_button.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/providers/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final bool isDarkMode = themeProvider.isDarkMode;

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
    final String dialogTitle = widget.existingCourse != null 
        ? tr('academicCareer.courseDialogTitleEdit') 
        : tr('academicCareer.courseDialogTitleAdd');
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final bool isDarkMode = themeProvider.isDarkMode;
    
    return AlertDialog(
      backgroundColor: isDarkMode ? DarkThemeColors.background : LightTheme.background,
      title: Text(dialogTitle, style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor)),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.9,   
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_courseNameController, tr('academicCareer.courseDialogLabelCourseName'), isDarkMode),
              _buildTextField(_courseCodeController, tr('academicCareer.courseDialogLabelCourseCode'), isDarkMode),
              CheckboxListTile(
                title: Text(tr('academicCareer.courseDialogCheckboxPassFail'), style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor)),
                value: _isPassFailCourse,
                activeColor: isDarkMode ? DarkThemeColors.primary : LightTheme.primary,
                checkColor: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isPassFailCourse = newValue!;
                    _updateGradeAndLetterFields();
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              _buildTextField(_courseScoreController, tr('academicCareer.courseDialogLabelCourseScore'), isDarkMode, keyboardType: TextInputType.number),
              _buildTextField(_gradeController, tr('academicCareer.courseDialogLabelGrade'), isDarkMode, keyboardType: TextInputType.number, enabled: false),
              _buildTextField(_creditHoursController, tr('academicCareer.courseDialogLabelCreditHours'), isDarkMode, keyboardType: TextInputType.number),
              _buildTextField(_gradeLetterController, tr('academicCareer.courseDialogLabelGradeLetter'), isDarkMode, enabled: false),
            ],
          ),
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
            print("CourseDialog: Add/Save button pressed.");
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
          child: Text(widget.existingCourse != null ? tr('academicCareer.courseDialogButtonSaveChanges') : tr('academicCareer.addNewCourseButton')),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, bool isDarkMode, {TextInputType? keyboardType, bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
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
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? DarkThemeColors.textcolor.withOpacity(0.3) : LightTheme.textcolor.withOpacity(0.3)),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
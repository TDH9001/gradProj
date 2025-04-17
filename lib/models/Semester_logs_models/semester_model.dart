import 'package:grad_proj/models/Semester_logs_models/course_model.dart';

class SemesterModel {
  final List<CourseModel> courses;
  final String semesterYear;
  final String semesterName;
  final int semesterNumber;
  late int totalCreditHours;
  late double semmesterGpa;
  late double semesterGrade;

  SemesterModel(
      this.courses, this.semesterYear, this.semesterName, this.semesterNumber) {
    //calculate the 3 late parameters [totalCreditHours, semmesterGpa,  semesterGrade]
  }
}

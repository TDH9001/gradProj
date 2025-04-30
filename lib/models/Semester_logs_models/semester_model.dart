import 'package:grad_proj/models/Semester_logs_models/course_model.dart';

class SemesterModel {
  final List<CourseModel> courses;
  final String semesterYear;
  final String semesterName;
  final int semesterNumber;
  late int totalCreditHours; //  in the semester
  late double semmesterGpa; //
  late Grades semesterGrade;

  SemesterModel(
      this.courses, this.semesterYear, this.semesterName, this.semesterNumber) {
    //calculate the 3 late parameters [totalCreditHours, semmesterGpa,  semesterGrade]
  }
}

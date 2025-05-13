import 'package:grad_proj/models/Semester_logs_models/course_model.dart';
import 'package:grad_proj/utils/grade_utils.dart';

class SemesterModel {
  final List<CourseModel> courses;
  final String semesterYear;
  final String semesterName;
  final int semesterNumber;
  late int totalCreditHours;
  late double semmesterGpa;
  late Grades semesterGrade;
  late String level;

  SemesterModel(
    this.courses,
    this.semesterYear,
    this.semesterName,
    this.semesterNumber,
  ) {

    totalCreditHours = GradeUtils.calculateCurrentSemesterCreditHours(this);
    semmesterGpa = GradeUtils.calculateSemesterGPA(this);
    semesterGrade = GradeUtils.getSemesterLetterFromGPA(semmesterGpa);
    level = GradeUtils.calculateSemesterLevel(totalCreditHours);
  }

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      (json['courses'] as List<dynamic>)
          .map((c) => CourseModel.fromJson(c as Map<String, dynamic>))
          .toList(),
      json['semesterYear'] ?? '',
      json['semesterName'] ?? '',
      json['semesterNumber'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courses': courses.map((c) => c.toJson()).toList(),
      'semesterYear': semesterYear,
      'semesterName': semesterName,
      'semesterNumber': semesterNumber,
      'totalCreditHours': totalCreditHours,
      'semmesterGpa': semmesterGpa,
      'semesterGrade': semesterGrade.toString(),
      'level': level,
    };
  }


  void addCourse(CourseModel course) {
    courses.add(course);
    _recalculate();
  }


  void removeCourseAt(int index) {
    if (index >= 0 && index < courses.length) {
      courses.removeAt(index);
      _recalculate();
    }
  }

  void removeCourseByCode(String courseCode) {
    courses.removeWhere((course) => course.courseCode == courseCode);
    _recalculate();
  }

  void editCourseAt(int index, CourseModel newCourse) {
    if (index >= 0 && index < courses.length) {
      courses[index] = newCourse;
      _recalculate();
    }
  }

  void _recalculate() {
    totalCreditHours = GradeUtils.calculateCurrentSemesterCreditHours(this);
    semmesterGpa = GradeUtils.calculateSemesterGPA(this);
    semesterGrade = GradeUtils.getSemesterLetterFromGPA(semmesterGpa);
    level = GradeUtils.calculateSemesterLevel(totalCreditHours);
  }
}

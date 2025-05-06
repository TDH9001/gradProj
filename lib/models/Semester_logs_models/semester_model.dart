import 'package:grad_proj/models/Semester_logs_models/course_model.dart';

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

    totalCreditHours = courses.fold(0, (sum, course) => sum + course.creditHours);


    double totalWeightedGrade = 0;
    int totalCredits = 0;
    for (var course in courses) {
      totalWeightedGrade += course.grade * course.creditHours;
      totalCredits += course.creditHours;
    }
    semmesterGpa = totalCredits > 0 ? totalWeightedGrade / totalCredits : 0;

    semesterGrade = _getGradeFromGpa(semmesterGpa);


    if (totalCreditHours < 33) {
      level = "الأول";
    } else if (totalCreditHours < 67) {
      level = "الثاني";
    } else if (totalCreditHours < 101) {
      level = "الثالث";
    } else {
      level = "الرابع";
    }
  }

  Grades _getGradeFromGpa(double gpa) {
    if (gpa >= 3.7) return Grades.A;
    if (gpa >= 3.3) return Grades.A_Minus;
    if (gpa >= 3.0) return Grades.B_Plus;
    if (gpa >= 2.7) return Grades.B_Minus;
    if (gpa >= 2.3) return Grades.C_Plus;
    if (gpa >= 2.0) return Grades.C;
    if (gpa >= 1.0) return Grades.D;
    return Grades.F;
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
}

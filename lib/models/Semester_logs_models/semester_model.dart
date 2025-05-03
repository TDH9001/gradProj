import 'package:grad_proj/models/Semester_logs_models/course_model.dart';

class SemesterModel {
  final List<CourseModel> courses;
  final String semesterYear;
  final String semesterName;
  final int semesterNumber;
  late int totalCreditHours;
  late double semmesterGpa;
  late Grades semesterGrade;
  late String level; // <-- Add this variable

  SemesterModel(
    this.courses,
    this.semesterYear,
    this.semesterName,
    this.semesterNumber,
  ) {
    // Calculate total credit hours
    totalCreditHours = courses.fold(0, (sum, course) => sum + course.creditHours);

    // Calculate weighted GPA
    double totalWeightedGrade = 0;
    int totalCredits = 0;
    for (var course in courses) {
      totalWeightedGrade += course.grade * course.creditHours;
      totalCredits += course.creditHours;
    }
    semmesterGpa = totalCredits > 0 ? totalWeightedGrade / totalCredits : 0;

    // Map GPA to semesterGrade (adjust thresholds as needed)
    semesterGrade = _getGradeFromGpa(semmesterGpa);

    // Set the level based on totalCreditHours
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
}

import 'package:grad_proj/models/Semester_logs_models/semester_model.dart';

class AcademicCareer {
  final List<SemesterModel> semesters;
  final int succesHours;
  late double gpa;
  late int totalGrade;
  final String seatNumber; // Add seatNumber field is the رقم الجلوس

  AcademicCareer({
    required this.semesters,
    required this.succesHours,
    required this.seatNumber,
  }) {
    // Calculate cumulative GPA
    int totalCredits = 0;
    double totalWeightedGpa = 0.0;
    for (var semester in semesters) {
      totalWeightedGpa += semester.semmesterGpa * semester.totalCreditHours;
      totalCredits += semester.totalCreditHours;
    }
    gpa = totalCredits > 0 ? totalWeightedGpa / totalCredits : 0.0;

    // Example: totalGrade as integer mapping of GPA (you can adjust this logic)
    totalGrade = _getTotalGradeFromGpa(gpa);
  }

  int _getTotalGradeFromGpa(double gpa) {
    if (gpa >= 3.7) return 1; // Excellent
    if (gpa >= 3.0) return 2; // Very Good
    if (gpa >= 2.0) return 3; // Good
    if (gpa >= 1.0) return 4; // Pass
    return 5; // Fail
  }
}

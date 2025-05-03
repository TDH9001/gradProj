enum Grades { A, A_Minus, B_Plus, B_Minus, C_Plus, C, D, F }

class CourseModel {
  final String courseCode;
  final String courseName;
  final double grade; // <-- changed from int to double
  final int creditHours;
  final double courseScore;
  String? gradeLetter;

  CourseModel({
    required this.courseCode,
    required this.courseName,
    required this.grade, // <-- changed from int to double
    required this.creditHours,
    required this.courseScore,
    this.gradeLetter,
  });
}

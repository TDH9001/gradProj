enum Grades { A, A_Minus, B_Plus, B_Minus, C_Plus, C, D, F }

class CourseModel {
  final String courseCode;
  final String courseName;
  final double grade;
  final int creditHours;
  final double courseScore;
  final Grades? gradeLetter;

  CourseModel({
    required this.courseCode,
    required this.courseName,
    required this.grade,
    required this.creditHours,
    required this.courseScore,
    this.gradeLetter,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    Grades? parseGradeLetter(String? value) {
      if (value == null) return null;
      switch (value.replaceAll('Grades.', '').toUpperCase()) {
        case 'A':
          return Grades.A;
        case 'A_MINUS':
        case 'A-':
          return Grades.A_Minus;
        case 'B_PLUS':
        case 'B+':
          return Grades.B_Plus;
        case 'B_MINUS':
        case 'B-':
          return Grades.B_Minus;
        case 'C_PLUS':
        case 'C+':
          return Grades.C_Plus;
        case 'C':
          return Grades.C;
        case 'D':
          return Grades.D;
        case 'F':
          return Grades.F;
        default:
          return null;
      }
    }

    return CourseModel(
      courseCode: json['courseCode'] ?? '',
      courseName: json['courseName'] ?? '',
      grade: (json['grade'] as num?)?.toDouble() ?? 0.0,
      creditHours: json['creditHours'] ?? 0,
      courseScore: (json['courseScore'] as num?)?.toDouble() ?? 0.0,
      gradeLetter: parseGradeLetter(json['gradeLetter']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'grade': grade,
      'creditHours': creditHours,
      'courseScore': courseScore,
      'gradeLetter': gradeLetter?.toString(),
    };
  }
}

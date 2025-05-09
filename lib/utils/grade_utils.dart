import 'package:grad_proj/models/Semester_logs_models/semester_model.dart';

import '../models/Semester_logs_models/course_model.dart';

class GradeUtils {
  static Map<String, dynamic> calculateGradeAndLetterFromScore(double score) {
    double grade;
    Grades gradeLetter;

    if (score >= 90) {
      grade = 4.0;
      gradeLetter = Grades.A;
    } else if (score >= 85) {
      grade = 3.7;
      gradeLetter = Grades.A_Minus;
    } else if (score >= 80) {
      grade = 3.3;
      gradeLetter = Grades.B_Plus;
    } else if (score >= 75) {
      grade = 3.0;
      gradeLetter = Grades.B_Minus;
    } else if (score >= 70) {
      grade = 2.7;
      gradeLetter = Grades.C_Plus;
    } else if (score >= 65) {
      grade = 2.3;
      gradeLetter = Grades.C;
    } else if (score >= 60) {
      grade = 2.0;
      gradeLetter = Grades.D;
    } else {
      grade = 0.0;
      gradeLetter = Grades.F;
    }

    return {
      'grade': grade,
      'gradeLetter': gradeLetter,
    };
  }

  static Grades? parseGradeLetter(String? input) {
    switch (input?.toUpperCase()) {
      case "A":
        return Grades.A;
      case "A-":
      case "A_MINUS":
        return Grades.A_Minus;
      case "B+":
      case "B_PLUS":
        return Grades.B_Plus;
      case "B-":
      case "B_MINUS":
        return Grades.B_Minus;
      case "C+":
      case "C_PLUS":
        return Grades.C_Plus;
      case "C":
        return Grades.C;
      case "D":
        return Grades.D;
      case "F":
        return Grades.F;
      default:
        return null;
    }
  }

  void updateSemesterLevel(SemesterModel semester) {
    semester.totalCreditHours = semester.courses.fold(0, (sum, course) => sum + course.creditHours);

    if (semester.totalCreditHours < 33) {
      semester.level = "الأول";
    } else if (semester.totalCreditHours < 67) {
      semester.level = "الثاني";
    } else if (semester.totalCreditHours < 101) {
      semester.level = "الثالث";
    } else {
      semester.level = "الرابع";
    }
  }

  double calculateSemesterGPA(SemesterModel semester) {
    if (semester.courses.isEmpty) return 0.0;
    return semester.courses.fold(0.0, (sum, course) => sum + course.grade) / semester.courses.length;
  }

  double calculateCumulativeGPA(List<SemesterModel> semesters) {
    double totalGradePoints = 0.0;
    int totalCourses = 0;
    
    for (var semester in semesters) {
      for (var course in semester.courses) {
        totalGradePoints += course.grade;
        totalCourses++;
      }
    }
    
    return totalCourses > 0 ? totalGradePoints / totalCourses : 0.0;
  }

  int calculateTotalCreditHours(List<SemesterModel> semesters) {
    int totalCreditHours = 0;
    for (var semester in semesters) {
      totalCreditHours += semester.courses.fold(0, (sum, course) => sum + course.creditHours);
    }
    return totalCreditHours;
  }

  String getStudentStatus(double gpa) {
    if (gpa >= 3.7) {
      return "الحالة: ممتاز مع مرتبة الشرف";
    } else if (gpa >= 3.3) {
      return "الحالة: جيد جداً";
    } else if (gpa >= 2.7) {
      return "الحالة: جيد";
    } else if (gpa >= 2.0) {
      return "الحالة: مقبول";
    } else {
      return "الحالة: تحت المراقبة الأكاديمية";
    }
  }
  static String calculateSemesterLevel(int totalCreditHours) {
    if (totalCreditHours < 33) {
      return "الأول";
    } else if (totalCreditHours < 67) {
      return "الثاني";
    } else if (totalCreditHours < 101) {
      return "الثالث";
    } else {
      return "الرابع";
    }
  }
}

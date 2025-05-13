import 'package:grad_proj/models/Semester_logs_models/semester_model.dart';

import '../models/Semester_logs_models/course_model.dart';

class GradeUtils {
  static Map<String, dynamic> calculateGradeAndLetterFromScore(double score) {
    double grade;
    Grades gradeLetter;

    if (score >= 90) {
      grade = 4.00;
      gradeLetter = Grades.A;
    } else if (score >= 85) {
      grade = 3.67;
      gradeLetter = Grades.A_Minus;
    } else if (score >= 80) {
      grade = 3.30;
      gradeLetter = Grades.B_Plus;
    } else if (score >= 75) {
      grade = 3.00;
      gradeLetter = Grades.B;
    } else if (score >= 70) {
      grade = 2.67;
      gradeLetter = Grades.C_Plus;
    } else if (score >= 65) {
      grade = 2.33;
      gradeLetter = Grades.C;
    } else if (score >= 60) {
      grade = 2.00;
      gradeLetter = Grades.D;
    } else {
      grade = 0.00;
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
      case "B":
        return Grades.B;
      case "C+":
      case "C_PLUS":
        return Grades.C_Plus;
      case "C":
        return Grades.C;
      case "D":
        return Grades.D;
      case "F":
        return Grades.F;
      case "P":
        return Grades.P;
      default:
        return null;
    }
  }

  static double calculateSemesterGPA(SemesterModel semester) {
    if (semester.courses.isEmpty) return 0.0;

    double totalQualityPoints = 0.0;
    int totalCreditHours = 0;

    for (var course in semester.courses) {
      totalQualityPoints += course.grade * course.creditHours;
      totalCreditHours += course.creditHours;
    }

    if (totalCreditHours == 0) return 0.0;
    
    double gpa = totalQualityPoints / totalCreditHours;
    return (gpa * 1000).roundToDouble() / 1000.0;
  }

  static double calculateCumulativeGPA(List<SemesterModel> semesters) {
    double totalQualityPoints = 0.0;
    int totalCreditHours = 0;
    
    for (var semester in semesters) {
      for (var course in semester.courses) {
        totalQualityPoints += course.grade * course.creditHours;
        totalCreditHours += course.creditHours;
      }
    }
    
    if (totalCreditHours == 0) return 0.0;
    
    double cGPA = totalQualityPoints / totalCreditHours;
    return (cGPA * 1000).roundToDouble() / 1000.0;
  }

  static int calculateTotalCreditHours(List<SemesterModel> semesters) {
    int totalCreditHours = 0;
    for (var semester in semesters) {
      totalCreditHours += semester.courses.fold(0, (sum, course) => sum + course.creditHours);
    }
    return totalCreditHours;
  }

  static int calculateCurrentSemesterCreditHours(SemesterModel semester) {
    if (semester.courses.isEmpty) return 0;
    return semester.courses.fold(0, (sum, course) => sum + course.creditHours);
  }

  static String getStudentStatus(double gpa) {
    if (gpa >= 3.7) {
      return "الحالة: ممتاز مع مرتبة الشرف";
    } else if (gpa >= 3.00) {
      return "الحالة: جيد جداً";
    } else if (gpa >= 2.33) {
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

  static Grades getSemesterLetterFromGPA(double semesterGPA) {
    if (semesterGPA >= 3.84) return Grades.A;
    if (semesterGPA >= 3.50) return Grades.A_Minus;
    if (semesterGPA >= 3.17) return Grades.B_Plus;
    if (semesterGPA >= 2.84) return Grades.B; 
    if (semesterGPA >= 2.50) return Grades.C_Plus;
    if (semesterGPA >= 2.17) return Grades.C;  
    if (semesterGPA >= 1.50) return Grades.D;
    return Grades.F;
  }

  static int getAcademicRankFromGPA(double cumulativeGPA) {
    if (cumulativeGPA >= 3.7) return 1;
    if (cumulativeGPA >= 3.0) return 2;
    if (cumulativeGPA >= 2.0) return 3;
    if (cumulativeGPA >= 1.0) return 4;
    return 5;
  }

  static String getCumulativeGPALetter(double cumulativeGPA) {
    if (cumulativeGPA >= 3.7) return "A";
    if (cumulativeGPA >= 3.3) return "B"; 
    if (cumulativeGPA >= 2.7) return "C"; 
    if (cumulativeGPA >= 2.0) return "D"; 
    return "F"; 
  }

  static int calculateTotalPassedAcademicCredits(List<SemesterModel> semesters) {
    int totalPassedCredits = 0;
    for (var semester in semesters) {
      for (var course in semester.courses) {

        if (course.gradeLetter != Grades.F) {
          totalPassedCredits += course.academicCredits;
        }
      }
    }
    return totalPassedCredits;
  }
}

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
    //calculate the 2 late fields [totalGrade, gpa]
  }
}

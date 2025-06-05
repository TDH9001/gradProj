import 'package:grad_proj/models/Semester_logs_models/semester_model.dart';
import 'package:grad_proj/utils/grade_utils.dart';

class AcademicCareer {
  final List<SemesterModel> semesters;
  late int succesHours;
  late double gpa;
  late int totalGrade;
  late String seatNumber;

  AcademicCareer({
    required this.semesters,
    required this.succesHours,
    required this.seatNumber,
  }) {
    gpa = GradeUtils.calculateCumulativeGPA(semesters);
    totalGrade = GradeUtils.getAcademicRankFromGPA(gpa);
  }

  factory AcademicCareer.fromJson(Map<String, dynamic> json) {
    return AcademicCareer(
      semesters: (json['semesters'] as List<dynamic>)
          .map((s) => SemesterModel.fromJson(Map<String, dynamic>.from(s as Map))) 
          .toList(),
      succesHours: json['succesHours'] ?? 0,
      seatNumber: json['seatNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'semesters': semesters.map((s) => s.toJson()).toList(),
      'succesHours': succesHours,
      'gpa': gpa,
      'totalGrade': totalGrade,
      'seatNumber': seatNumber,
    };
  }

  Map<String, dynamic> getDataForDatabase() {
    return toJson();
  }
  Future<void> saveToDatabase(Function(Map<String, dynamic>) saveCallback) async {
    final data = toJson();
    saveCallback(data);
    
  }
}

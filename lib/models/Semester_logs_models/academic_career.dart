import 'package:grad_proj/models/Semester_logs_models/semester_model.dart';

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

    int totalCredits = 0;
    double totalWeightedGpa = 0.0;
    for (var semester in semesters) {
      totalWeightedGpa += semester.semmesterGpa * semester.totalCreditHours;
      totalCredits += semester.totalCreditHours;
    }
    gpa = totalCredits > 0 ? totalWeightedGpa / totalCredits : 0.0;

    totalGrade = _getTotalGradeFromGpa(gpa);
  }

  int _getTotalGradeFromGpa(double gpa) {
    if (gpa >= 3.7) return 1; 
    if (gpa >= 3.0) return 2; 
    if (gpa >= 2.0) return 3; 
    if (gpa >= 1.0) return 4; 
    return 5; 
  }

  factory AcademicCareer.fromJson(Map<String, dynamic> json) {
    return AcademicCareer(
      semesters: (json['semesters'] as List<dynamic>)
          .map((s) => SemesterModel.fromJson(s as Map<String, dynamic>))
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
    /**if you use firebase or another async API, replace the above with your actual save logic
     Example for Firebase:
     await FirebaseFirestore.instance.collection('academic_careers').doc(seatNumber).set(data); */
    
  }
}

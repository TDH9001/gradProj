import 'package:flutter/material.dart';
import 'package:grad_proj/utils/grade_utils.dart';
import '../models/Semester_logs_models/academic_career.dart';
import '../models/Semester_logs_models/semester_model.dart';
import '../models/Semester_logs_models/course_model.dart';

class AcademicCareerProvider extends ChangeNotifier {
  AcademicCareer? _academicCareer;
  int _selectedSemesterIndex = 0;

  AcademicCareer? get academicCareer => _academicCareer;
  int get selectedSemesterIndex => _selectedSemesterIndex;
  SemesterModel? get selectedSemester => 
      _academicCareer != null && _academicCareer!.semesters.isNotEmpty 
      ? _academicCareer!.semesters[_selectedSemesterIndex]
      : null;
  
  bool get isEmpty => _academicCareer == null || _academicCareer!.semesters.isEmpty;

  void initializeCareer(AcademicCareer? career) {
    if (career == null) {
      _academicCareer = null;
    } else {
      _academicCareer = career;
      _updateCareerSummaryFields();
    }
    _selectedSemesterIndex = 0;
    notifyListeners();
  }

  void _updateCareerSummaryFields() {
    if (_academicCareer != null) {
      _academicCareer!.gpa = GradeUtils.calculateCumulativeGPA(_academicCareer!.semesters);
      _academicCareer!.totalGrade = GradeUtils.getAcademicRankFromGPA(_academicCareer!.gpa);
      _academicCareer!.succesHours = GradeUtils.calculateTotalPassedAcademicCredits(_academicCareer!.semesters);
    }
  }

  void setSelectedSemesterIndex(int index) {
    if (_academicCareer != null && index >= 0 && index < _academicCareer!.semesters.length) {
      _selectedSemesterIndex = index;
      notifyListeners();
    }
  }

  void addSemester(SemesterModel semester) {
    if (_academicCareer == null) {
      _academicCareer = AcademicCareer(
        semesters: [semester],
        succesHours: 0,
        seatNumber: "",
      );
    } else {
      _academicCareer!.semesters.add(semester);
    }
    _updateCareerSummaryFields();
    _selectedSemesterIndex = _academicCareer!.semesters.length - 1;
    notifyListeners();
  }

  void addCourseToSelectedSemester(CourseModel course) {
    if (_academicCareer != null && selectedSemester != null) {
      print("AcademicCareerProvider: Adding course: ${course.toJson()} to semester: ${selectedSemester!.semesterName}");
      selectedSemester!.addCourse(course);
      _updateCareerSummaryFields();
      notifyListeners();
    }
  }

  void updateCourseInSelectedSemester(int index, CourseModel course) {
    if (_academicCareer != null && selectedSemester != null) {
      selectedSemester!.editCourseAt(index, course);
      _updateCareerSummaryFields();
      notifyListeners();
    }
  }

  void deleteCourseFromSelectedSemester(int index) {
    if (_academicCareer != null && selectedSemester != null) {
      selectedSemester!.removeCourseAt(index);
      _updateCareerSummaryFields();
      notifyListeners();
    }
  }

  double calculateCumulativeGPA() {
    if (_academicCareer == null) return 0.0;
    return GradeUtils.calculateCumulativeGPA(_academicCareer!.semesters);
  }

  int calculateTotalCreditHours() {
    if (_academicCareer == null) return 0;
    return GradeUtils.calculateTotalCreditHours(_academicCareer!.semesters);
  }

  void updateSeatNumber(String seatNumber) {
    if (_academicCareer != null) {
      _academicCareer!.seatNumber = seatNumber;
      notifyListeners();
    }
  }

  void updateSuccessHours(int hours) {
    if (_academicCareer != null) {
      _academicCareer!.succesHours = hours;
      notifyListeners();
    }
  }
}
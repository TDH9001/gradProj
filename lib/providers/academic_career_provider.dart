import 'package:flutter/material.dart';
import 'package:grad_proj/models/Semester_logs_models/academic_career.dart';
import 'package:grad_proj/models/Semester_logs_models/course_model.dart';
import 'package:grad_proj/models/Semester_logs_models/semester_model.dart';
import 'package:grad_proj/services/hive_caching_service/hive_academic_career_caching_service.dart';
import 'package:grad_proj/utils/grade_utils.dart';
import 'package:grad_proj/services/pdf_parsing_service.dart'; 
import 'dart:io'; 

class AcademicCareerProvider with ChangeNotifier {
  AcademicCareer? _academicCareer;
  int _selectedSemesterIndex = 0;
  final PdfParsingService _pdfParsingService = PdfParsingService(); 

  AcademicCareer? get academicCareer => _academicCareer;
  bool get isEmpty => _academicCareer == null || _academicCareer!.semesters.isEmpty;

  SemesterModel? get selectedSemester {
    if (_academicCareer == null || _academicCareer!.semesters.isEmpty || _selectedSemesterIndex < 0 || _selectedSemesterIndex >= _academicCareer!.semesters.length) {
      return null;
    }
    return _academicCareer!.semesters[_selectedSemesterIndex];
  }

  int get selectedSemesterIndex => _selectedSemesterIndex;

 
  Future<void> initializeCareer([AcademicCareer? sampleCareer]) async {
    _academicCareer = HiveAcademicCareerCachingService.getAcademicCareer();
    if (_academicCareer == null && sampleCareer != null) {
      _academicCareer = sampleCareer;
     
      await HiveAcademicCareerCachingService.saveAcademicCareer(_academicCareer!); 
      print("AcademicCareerProvider: Saved sample career to Hive."); 
    } else if (_academicCareer != null) {
      print("AcademicCareerProvider: Loaded career from Hive."); 
    } else if (_academicCareer == null) {
        print("AcademicCareerProvider: No career in Hive and no sample provided."); 
    }

    if (_academicCareer != null && _academicCareer!.semesters.isNotEmpty) {
      _selectedSemesterIndex = 0;
    } else {
      _selectedSemesterIndex = -1;
    }
    notifyListeners();
  }

  Future<void> _saveCareerToHive() async {
    if (_academicCareer != null) {
      await HiveAcademicCareerCachingService.saveAcademicCareer(_academicCareer!);
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
      _academicCareer = AcademicCareer(semesters: [], seatNumber: "student123", succesHours: 0);
    }
    _academicCareer!.semesters.add(semester);
    _academicCareer!.gpa = GradeUtils.calculateCumulativeGPA(_academicCareer!.semesters); 
    _academicCareer!.totalGrade = GradeUtils.getAcademicRankFromGPA(_academicCareer!.gpa);
    
    _selectedSemesterIndex = _academicCareer!.semesters.length - 1;
    _saveCareerToHive();
    notifyListeners();
  }

  void addCourseToSelectedSemester(CourseModel course) {
    if (selectedSemester != null) {
      selectedSemester!.addCourse(course); 
      _academicCareer!.gpa = GradeUtils.calculateCumulativeGPA(_academicCareer!.semesters);
      _academicCareer!.totalGrade = GradeUtils.getAcademicRankFromGPA(_academicCareer!.gpa);
      _saveCareerToHive();
      notifyListeners();
    }
  }

  void updateCourseInSelectedSemester(int courseIndex, CourseModel newCourse) {
    if (selectedSemester != null) {
      selectedSemester!.editCourseAt(courseIndex, newCourse);
      _academicCareer!.gpa = GradeUtils.calculateCumulativeGPA(_academicCareer!.semesters);
      _academicCareer!.totalGrade = GradeUtils.getAcademicRankFromGPA(_academicCareer!.gpa);
      _saveCareerToHive();
      notifyListeners();
    }
  }

  void deleteCourseFromSelectedSemester(int courseIndex) {
    if (selectedSemester != null) {
      selectedSemester!.removeCourseAt(courseIndex);
      _academicCareer!.gpa = GradeUtils.calculateCumulativeGPA(_academicCareer!.semesters);
      _academicCareer!.totalGrade = GradeUtils.getAcademicRankFromGPA(_academicCareer!.gpa);
      _saveCareerToHive();
      notifyListeners();
    }
  }

  Future<bool> importAcademicCareerFromPdf() async {
    File? pdfFile = await _pdfParsingService.pickPdfFile();
    if (pdfFile == null) {
      print("PDF import: No file selected.");
      return false; 
    }

    String? pdfText = await _pdfParsingService.extractTextFromFile(pdfFile);
    if (pdfText == null || pdfText.isEmpty) {
      print("PDF import: Could not extract text from PDF or text is empty.");
      return false; 
    }

    AcademicCareer? importedCareer = await _pdfParsingService.parseTextToAcademicCareer(pdfText);

    if (importedCareer != null) {
      _academicCareer = importedCareer;
      
      _selectedSemesterIndex = (_academicCareer!.semesters.isNotEmpty) ? 0 : -1;
      await _saveCareerToHive();
      notifyListeners();
      print("PDF import: Successfully parsed and saved academic career.");
      return true;
    } else {
      print("PDF import: Failed to parse academic career from PDF text.");
      return false;
    }
  }
}
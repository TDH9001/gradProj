import 'package:flutter/material.dart';

class AppStrings {
  // Common
  static const String cancel = "Cancel";
  static const String save = "Save";
  static const String edit = "Edit";
  static const String delete = "Delete";
  
  // Screen Titles
  static const String academicCareer = "Academic Career";
  static const String emptyCareerMessage = "No academic career data found.\nPlease start by adding your data.";
  
  // Dialog Titles
  static const String addCourse = "Add New Course";
  static const String editCourse = "Edit Course";
  static const String addSemester = "Add New Semester";
  static const String addCourseToSemester = "Add Course to Semester";
  
  // Form Labels
  static const String courseName = "Course Name";
  static const String courseCode = "Course Code";
  static const String courseScore = "Course Score";
  static const String grade = "Grade";
  static const String creditHours = "Credit Hours";
  static const String gradeLetter = "Grade Letter";
  static const String semesterYear = "Semester Year";
  static const String semesterName = "Semester Name";
  static const String semesterNumber = "Semester Number";
  
  // Button Labels
  static const String addNewCourse = "إضافة مقرر جديد";
  static const String addNewSemester = "إضافة فصل دراسي جديد";
  
  // Student Information
  static const String studentInfo = "معلومات الطالب";
  static const String name = "الاسم:";
  static const String nationalId = "الرقم القومي:";
  static const String nationality = "الجنسية:";
  static const String seatNumber = "رقم المقعد:";
  static const String passedHours = "الساعات المجتازة:";
  static const String totalCreditHours = "إجمالي الساعات المعتمدة:";
  static const String cumulativeGPA = "المعدل التراكمي:";
  static const String semesterCount = "عدد الفصول الدراسية:";
  
  // Semester Information
  static const String semesterGPA = "معدل درجات الفصل الدراسي:";
  static const String passedCreditHours = "عدد الساعات المعتمدة المجتازة:";
  static const String levelInfo = "المستوى:";
  static const String mathProgram = "برنامج الرياضيات";
  static const String semesterLabel = "فصل";
  
  // Summary Section
  static const String totalCredits = "Total Credits:";

  // Placeholders
  static const String notSpecified = "غير محدد";
  static const String coursesInSemester = "Courses in this semester:";
}

class AppDimensions {
  // Padding
  static const double smallPadding = 4.0;
  static const double mediumPadding = 8.0;
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  
  // Margins
  static const EdgeInsets defaultCardMargin = EdgeInsets.all(16.0);
  static const EdgeInsets smallVerticalMargin = EdgeInsets.symmetric(vertical: 4.0);
  static const EdgeInsets mediumVerticalMargin = EdgeInsets.symmetric(vertical: 8.0);
  
  // Border Radius
  static final BorderRadius smallRadius = BorderRadius.circular(6.0);
  static final BorderRadius defaultRadius = BorderRadius.circular(8.0);
  static final BorderRadius largeRadius = BorderRadius.circular(12.0);
  
  // Text Sizes
  static const double smallText = 14.0;
  static const double defaultText = 15.0;
  static const double mediumText = 16.0;
  static const double largeText = 18.0;
}

class AppIcons {
  static const IconData student = Icons.school;
  static const IconData person = Icons.person;
  static const IconData id = Icons.badge;
  static const IconData nationality = Icons.public;
  static const IconData seatNumber = Icons.numbers;
  static const IconData hours = Icons.access_time_filled;
  static const IconData creditHours = Icons.credit_card;
  static const IconData gpa = Icons.grade;
  static const IconData calendar = Icons.calendar_month;
  static const IconData addCourse = Icons.add;
  static const IconData addSemester = Icons.add_to_photos;
}
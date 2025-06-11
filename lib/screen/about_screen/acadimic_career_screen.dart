import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Semester_logs_models/academic_career.dart';
import 'package:grad_proj/models/Semester_logs_models/semester_model.dart';
import 'package:grad_proj/models/Semester_logs_models/course_model.dart';
import 'package:grad_proj/widgets/dialogs/course_dialog.dart';
import 'package:grad_proj/widgets/dialogs/semester_dialog.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';
import 'package:grad_proj/providers/theme_provider.dart';
import 'package:grad_proj/widgets/student_info_card.dart';
import 'package:grad_proj/widgets/summary_section_for_semester.dart';
import 'package:grad_proj/widgets/add_course_button.dart';
import 'package:grad_proj/widgets/semester_section.dart';
import 'package:grad_proj/widgets/courses_table.dart';
import 'package:grad_proj/widgets/semester_selector.dart';
import 'package:grad_proj/widgets/semester_summary_row.dart';
import 'package:grad_proj/providers/academic_career_provider.dart';
// import 'package:grad_proj/widgets/orgappbar.dart';

class AcademicCareerScreen extends StatelessWidget {
  final AcademicCareer? academicCareer;
  final bool isEmpty;

  const AcademicCareerScreen({Key? key, this.academicCareer})
      : isEmpty = false,
        super(key: key);

  const AcademicCareerScreen.empty({Key? key})
      : academicCareer = null,
        isEmpty = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final sampleCareer = academicCareer ?? _createSampleCareer();
    return ChangeNotifierProvider(
      create: (_) => AcademicCareerProvider()..initializeCareer(sampleCareer),
      child: const _AcademicCareerScreenContent(),
    );
  }

  // for testing
  AcademicCareer _createSampleCareer() {
    final courses = [
      CourseModel(
        courseCode: "MATH101",
        courseName: "Calculus I",
        grade: 3.7,
        creditHours: 3,
        courseScore: 85.0,
        gradeLetter: Grades.A,
        academicCredits: 3,
      ),
      CourseModel(
        courseCode: "PHYS101",
        courseName: "Physics I",
        grade: 3.3,
        creditHours: 4,
        courseScore: 80.0,
        gradeLetter: Grades.B_Plus,
        academicCredits: 4,
      ),
    ];

    final semester = SemesterModel(
      courses,
      "2024",
      "Fall",
      1,
    );

    return AcademicCareer(
      semesters: [semester],
      seatNumber: "12345",
      succesHours: 7,
    );
  }
}

class _AcademicCareerScreenContent extends StatelessWidget {
  const _AcademicCareerScreenContent({Key? key}) : super(key: key);


  Future<void> _handlePdfImport(BuildContext context) async {
    final provider = Provider.of<AcademicCareerProvider>(context, listen: false);
    bool success = await provider.importAcademicCareerFromPdf();

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr("academicCareer.importSuccess"))), 
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr("academicCareer.importFail"))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    final careerProvider = Provider.of<AcademicCareerProvider>(context);

    if (careerProvider.isEmpty) {
      return _buildEmptyScreen(context, isDarkMode, () => _handlePdfImport(context));
    }

    final selectedSemester = careerProvider.selectedSemester;
    if (selectedSemester == null) {
      return _buildEmptyScreen(context, isDarkMode, () => _handlePdfImport(context));
    }

    return Scaffold(
      
      appBar: AppBar( 
        title: Text(tr("academicCareer.title")),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf_outlined),
            tooltip: tr("academicCareer.importPdfTooltip"), 
            onPressed: () => _handlePdfImport(context),
          ),
        ],
      ),
      backgroundColor: isDarkMode
          ? DarkThemeColors.background
          : LightTheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StudentInfoCard(
                career: careerProvider.academicCareer!,
                isDarkMode: isDarkMode,
                studentName: "أحمد محمد السيد علي صقر",
                studentId: "30202302392839823",
                nationality: "مصري",
              ),
              const SizedBox(height: 18),
              SemesterSelector(
                selectedIndex: careerProvider.selectedSemesterIndex,
                semesters: careerProvider.academicCareer!.semesters,
                isDarkMode: isDarkMode,
                onChanged: (int newIndex) {
                  careerProvider.setSelectedSemesterIndex(newIndex);
                },
              ),
              const SizedBox(height: 8),
              SemesterSection(
                key: ValueKey("${selectedSemester.semesterYear}-${selectedSemester.semesterName}-${selectedSemester.semesterNumber}"),
                semester: selectedSemester,
                isDarkMode: isDarkMode,
                coursesTable: CoursesTable(
                  courses: selectedSemester.courses,
                  isDarkMode: isDarkMode,
                  semester: selectedSemester,
                  onEdit: (index, course) => _showEditCourseDialog(context, index, course),
                  onDelete: (index) {
                    careerProvider.deleteCourseFromSelectedSemester(index);
                  },
                ),
                summaryRow: SemesterSummaryRow(
                  semester: selectedSemester,
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(height: 16),
              AddCourseButton(
                onPressed: () => _showAddCourseDialog(context),
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 24),
              SummarySectionForSemester(
                semester: selectedSemester,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSemesterDialog(context),
        backgroundColor: isDarkMode ? DarkThemeColors.primary : LightTheme.primary,
        foregroundColor: isDarkMode ? DarkThemeColors.buttonTextColor : LightTheme.buttonTextColor,
        child: const Icon(Icons.add_to_photos),
        tooltip: tr("academicCareer.addSemesterTooltip"),
      ),
    );
  }

  Widget _buildEmptyScreen(BuildContext context, bool isDarkMode, VoidCallback onImportPdf) {
    return Scaffold(
     
      appBar: AppBar( 
        title: Text(tr("academicCareer.title")),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf_outlined),
            tooltip: tr("academicCareer.importPdfTooltip"), 
            onPressed: onImportPdf,
          ),
        ],
      ),
      backgroundColor: isDarkMode
          ? DarkThemeColors.background
          : LightTheme.background,
      body: Center(
        child: Text(
          tr("academicCareer.emptyScreenMessage"),
          style: TextStyle(
            fontSize: 18,
            color: isDarkMode
                ? DarkThemeColors.textcolor
                : LightTheme.textcolor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSemesterDialog(context),
        backgroundColor: isDarkMode ? DarkThemeColors.primary : LightTheme.primary,
        foregroundColor: isDarkMode ? DarkThemeColors.buttonTextColor : LightTheme.buttonTextColor,
        child: const Icon(Icons.add_to_photos),
        tooltip: tr("academicCareer.addSemesterTooltip"),
      ),
    );
  }

  void _showAddCourseDialog(BuildContext context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final careerProvider = Provider.of<AcademicCareerProvider>(context, listen: false);

    final result = await showDialog<CourseModel>(
      context: context,
      builder: (_) => CourseDialog(
        isDarkMode: isDarkMode,
        isNewCourse: true,
      ),
    );

    if (result != null) {
      careerProvider.addCourseToSelectedSemester(result);
    }
  }

  void _showEditCourseDialog(BuildContext context, int index, CourseModel course) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final careerProvider = Provider.of<AcademicCareerProvider>(context, listen: false);

    final result = await showDialog<CourseModel>(
      context: context,
      builder: (_) => CourseDialog(
        isDarkMode: isDarkMode,
        existingCourse: course,
      ),
    );

    if (result != null) {
      careerProvider.updateCourseInSelectedSemester(index, result);
    }
  }

  void _showAddSemesterDialog(BuildContext context) async {
    final careerProvider = Provider.of<AcademicCareerProvider>(context, listen: false);
    
    await showDialog(
      context: context,
      builder: (_) => SemesterDialog(
        onAddSemester: (semester) {
          careerProvider.addSemester(semester);
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Semester_logs_models/academic_career.dart';
import 'package:grad_proj/models/Semester_logs_models/semester_model.dart';
import 'package:grad_proj/models/Semester_logs_models/course_model.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/theme/light_theme.dart';
import 'package:grad_proj/theme/dark_theme_colors.dart';
import 'package:grad_proj/providers/theme_provider.dart';
class AcademicCareerScreen extends StatefulWidget {
  final AcademicCareer? academicCareer;

  const AcademicCareerScreen({Key? key, this.academicCareer}) : super(key: key);

  @override
  State<AcademicCareerScreen> createState() => _AcademicCareerScreenState();
}

class _AcademicCareerScreenState extends State<AcademicCareerScreen> {
  int selectedSemesterIndex = 0;

  
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _creditHoursController = TextEditingController();
  final TextEditingController _courseScoreController = TextEditingController();
  final TextEditingController _gradeLetterController = TextEditingController();

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _gradeController.dispose();
    _creditHoursController.dispose();
    _courseScoreController.dispose();
    _gradeLetterController.dispose();
    super.dispose();
  }

  void _showAddCourseDialog(SemesterModel semester) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Course'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _courseNameController,
                  decoration: const InputDecoration(labelText: 'Course Name'),
                ),
                TextField(
                  controller: _courseCodeController,
                  decoration: const InputDecoration(labelText: 'Course Code '),
                ),
                TextField(
                  controller: _gradeController,
                  decoration: const InputDecoration(labelText: 'Grade'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _creditHoursController,
                  decoration: const InputDecoration(labelText: 'Credit Hours'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _courseScoreController,
                  decoration: const InputDecoration(labelText: 'Course Score'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _gradeLetterController,
                  decoration: const InputDecoration(labelText: 'Grade Letter'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _courseNameController.clear();
                _courseCodeController.clear();
                _gradeController.clear();
                _creditHoursController.clear();
                _courseScoreController.clear();
                _gradeLetterController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  semester.courses.add(
                    CourseModel(
                      courseCode: _courseCodeController.text,
                      courseName: _courseNameController.text,
                      grade: double.tryParse(_gradeController.text) ?? 0, // <-- changed to double
                      creditHours: int.tryParse(_creditHoursController.text) ?? 0,
                      courseScore: double.tryParse(_courseScoreController.text) ?? 0,
                      gradeLetter: _gradeLetterController.text,
                    ),
                  );
                  
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
                });
                _courseNameController.clear();
                _courseCodeController.clear();
                _gradeController.clear();
                _creditHoursController.clear();
                _courseScoreController.clear();
                _gradeLetterController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  late AcademicCareer mockCareer; 

  @override
  void initState() {
    super.initState();
    mockCareer = widget.academicCareer ?? AcademicCareer(
      semesters: [
        SemesterModel(
          [
            CourseModel(
              courseCode: "CHEM 101",
              courseName: "كيمياء عامة (1)",
              grade: 3,
              creditHours: 3,
              courseScore: 122.0,
              gradeLetter: "B+",
            ),
            CourseModel(
              courseCode: "CHEM 103",
              courseName: "عملي كيمياء عامة (1)",
              grade: 2,
              creditHours: 1,
              courseScore: 44.0,
              gradeLetter: "A-",
            ),
          ],
          "2021-2022",
          "يناير",
          1,
        ),
        SemesterModel(
          [
            CourseModel(
              courseCode: "MATH 201",
              courseName: "رياضيات متقدمة",
              grade: 4,
              creditHours: 3,
              courseScore: 130.0,
              gradeLetter: "A",
            ),
          ],
          "2021-2022",
          "فبراير",
          2,
        ),
        
      ],
      succesHours: 16,
      seatNumber: "210237",
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    final semesters = mockCareer.semesters;
    final selectedSemester = semesters[selectedSemesterIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Academic Career"),
        backgroundColor: isDarkMode
            ? DarkThemeColors.secondary
            : LightTheme.secondary,
        elevation: 2,
      ),
      backgroundColor: isDarkMode
          ? DarkThemeColors.background
          : LightTheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildStudentInfoCard(mockCareer, isDarkMode),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: DropdownButton<int>(
                  value: selectedSemesterIndex,
                  dropdownColor: isDarkMode ? DarkThemeColors.primary : LightTheme.background,
                  iconEnabledColor: isDarkMode ? DarkThemeColors.secondary : LightTheme.primary,
                  style: TextStyle(
                    color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
                    fontWeight: FontWeight.bold,
                  ),
                  items: List.generate(
                    semesters.length,
                    (index) {
                      final sem = semesters[index];
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(
                          "${sem.semesterName} ${sem.semesterYear}",
                          style: TextStyle(
                            color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor,
                          ),
                        ),
                      );
                    },
                  ),
                  onChanged: (int? newIndex) {
                    if (newIndex != null) {
                      setState(() {
                        selectedSemesterIndex = newIndex;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              _buildSemesterSection(context, selectedSemester, isDarkMode),
              const SizedBox(height: 24),
              _buildSummarySectionForSemester(selectedSemester, isDarkMode),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCourseDialog(selectedSemester),
        backgroundColor: isDarkMode ? DarkThemeColors.secondary : LightTheme.secondary,
        child: const Icon(Icons.add),
        tooltip: 'إضافة مقرر جديد',
      ),
    );
  }

  Widget _buildStudentInfoCard(AcademicCareer career, bool isDarkMode) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: isDarkMode
          ? DarkThemeColors.primary
          : LightTheme.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("الطالب:", "احمد محمد السيد على صقر", isDarkMode, icon: Icons.person),
            _infoRow("رقم الجلوس:", career.seatNumber, isDarkMode, icon: Icons.confirmation_number),
            _infoRow("الرقم القومي:", "30210230102235", isDarkMode, icon: Icons.badge),
            _infoRow("برنامج:", "برنامج علوم الحاسب", isDarkMode, icon: Icons.school),
            _infoRow("الجنسية:", "مصري", isDarkMode, icon: Icons.flag),
            _infoRow("إجمالي عدد الساعات:", "${career.succesHours}", isDarkMode, icon: Icons.timelapse),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isDarkMode, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 18,
              color: isDarkMode
                  ? DarkThemeColors.secondary
                  : LightTheme.primary, 
            ),
          if (icon != null) const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDarkMode
                      ? DarkThemeColors.textcolor
                      : LightTheme.textcolor)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(value,
                  style: TextStyle(
                      fontSize: 15,
                      color: isDarkMode
                          ? DarkThemeColors.textcolor
                          : LightTheme.textcolor))),
        ],
      ),
    );
  }

  Widget _buildSemesterSection(BuildContext context, SemesterModel semester, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? DarkThemeColors.secondary.withOpacity(0.15) : LightTheme.secondary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            "المستوى: ${semester.level}  |  برنامج الرياضيات  |  ${semester.semesterYear}  |  فصل ${semester.semesterName}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDarkMode ? DarkThemeColors.secondary : LightTheme.secondary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildCoursesTable(semester.courses, isDarkMode),
        const SizedBox(height: 6),
        _buildSemesterSummaryRow(semester, isDarkMode),
      ],
    );
  }

  Widget _buildCoursesTable(List<CourseModel> courses, bool isDarkMode) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(
              isDarkMode
                  ? DarkThemeColors.secondary.withOpacity(0.2)
                  : LightTheme.secondary.withOpacity(0.2)),
          dataRowColor: MaterialStateProperty.all(
              isDarkMode
                  ? DarkThemeColors.background
                  : LightTheme.background),
          columnSpacing: 18,
          columns: [
            DataColumn(label: Text("Grade", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
            DataColumn(label: Text("Credit Hours", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
            DataColumn(label: Text("Course Score", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
            DataColumn(label: Text("Grade Letter", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
            DataColumn(label: Text("Course Name", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
            DataColumn(label: Text("Course Code", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
          ],
          rows: courses.map((course) {
            return DataRow(
              cells: [
                DataCell(Text(
                  course.grade.toStringAsFixed(3),
                  style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
                DataCell(Text(course.creditHours.toStringAsFixed(2), style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
                DataCell(Text(course.courseScore.toStringAsFixed(2), style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
                DataCell(Text(course.gradeLetter ?? "", style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
                DataCell(Text(course.courseName, style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
                DataCell(Text(course.courseCode, style: TextStyle(color: isDarkMode ? DarkThemeColors.textcolor : LightTheme.textcolor))),
              ],
            );
          }).toList(),
        ),
      );
    }

  Widget _buildSemesterSummaryRow(SemesterModel semester, bool isDarkMode) {
    double totalCreditHours = semester.courses.fold(0, (sum, c) => sum + c.creditHours);
    double gpa = semester.courses.isNotEmpty
        ? semester.courses.fold(0.0, (sum, c) => sum + c.grade) / semester.courses.length
        : 0;
    String gradeLetter = semester.courses.isNotEmpty ? (semester.courses.first.gradeLetter ?? "") : "";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? DarkThemeColors.secondary.withOpacity(0.10) : LightTheme.secondary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "عدد الساعات المعتمدة المجتازة: ${totalCreditHours.toStringAsFixed(1)} ، معدل درجات الفصل الدراسي: ${gpa.toStringAsFixed(3)} بتقدير: $gradeLetter",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isDarkMode ? DarkThemeColors.secondary : LightTheme.secondary,
        ),
      ),
    );
  }

  Widget _buildSummarySectionForSemester(SemesterModel semester, bool isDarkMode) {
    double totalCreditHours = semester.courses.fold(0, (sum, c) => sum + c.creditHours);
    double gpa = semester.courses.isNotEmpty
        ? semester.courses.fold(0.0, (sum, c) => sum + c.grade) / semester.courses.length
        : 0;
    String gradeLetter = semester.courses.isNotEmpty ? (semester.courses.first.gradeLetter ?? "") : "";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode
          ? DarkThemeColors.primary
          : LightTheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "المعدل التراكمي: ${gpa.toStringAsFixed(3)} ، التقدير التراكمي: $gradeLetter ، عدد ساعات النجاح المعتمدة: ${totalCreditHours.toStringAsFixed(1)}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? DarkThemeColors.textcolor
                    : LightTheme.textcolor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

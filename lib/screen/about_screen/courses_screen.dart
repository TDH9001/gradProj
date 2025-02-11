import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/orgappbar.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedLevel, selectedSemester;
  Map<String, List<String>> data = {
    "11": ["Math 101", "Math 102"],
    "12": ["Math 102"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Orgappbar(
        scaffoldKey: scaffoldKey,
        title: "Available Courses",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff769BC6), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectedInfo(),  // Display the selected info as text
              _buildDropdown("Select Level", ["1", "2", "3", "4", "All"], selectedLevel, (value) => setState(() => selectedLevel = value)),
              _buildDropdown("Select Semester", ["1", "2"], selectedSemester, (value) => setState(() => selectedSemester = value)),
              _buildCourseList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          filled: true,
          fillColor: Colors.white,
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xff769BC6)),
      ),
    );
  }

  Widget _buildSelectedInfo() {
    if (selectedLevel == null || selectedSemester == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Selected Level: $selectedLevel", style: const TextStyle(fontSize: 16,color: Colors.white60 )),
        Text("Selected Semester: $selectedSemester", style: const TextStyle(fontSize: 16, color: Colors.white60)),
        const SizedBox(height: 16),  // Adds space between the selected info and dropdowns
      ],
    );
  }

  Widget _buildCourseList() {
    String key = "${selectedLevel ?? ""}${selectedSemester ?? ""}";
    List<String>? courses = data[key];

    return courses == null
        ? Center(child: Text("No courses available", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700)))
        : Column(
      children: courses.map((course) {
        return Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.blue.withOpacity(0.2), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ExpansionTile(
              iconColor: Color(0xff769BC6),
              title: Text(course, style: const TextStyle(fontSize: 16, )),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Instructor: John Doe", style: TextStyle(fontSize: 16, color: Colors.black87)),
                      Text("Course Description: This course covers the basics of Mathematics, including Algebra, Geometry, and Trigonometry.", style: TextStyle(fontSize: 16, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

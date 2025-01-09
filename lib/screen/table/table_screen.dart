import 'package:flutter/material.dart';
import 'package:grad_proj/screen/table/tableform_screen.dart';

import '../../UI/colors.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedCourse;
  DateTime? selectedDay;
  TimeOfDay? selectedTime;
  final List<Map<String, dynamic>> tableData = [];

  // Function to show Date Picker
  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDay) {
      setState(() {
        selectedDay = picked;
      });
    }
  }

  // Function to show Time Picker
  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void addCourse() {
    if (selectedCourse != null && selectedDay != null && selectedTime != null) {
      setState(() {
        tableData.add({
          "course": selectedCourse!,
          "day": selectedDay!,
          "time": selectedTime!,
        });
        selectedCourse = null;
        selectedDay = null;
        selectedTime = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select all fields before adding a course."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF7F9FC), // خلفية ناعمة
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 15),
            // Section Title
            const Text(
              "Fill in the details to create your schedule",
              style: TextStyle(fontSize: 16, ),
            ),
            const SizedBox(height: 30),

            // Dropdown for Course
            DropdownButtonFormField<String>(
              items: ["Maths", "Physics", "Chemistry", "Biology"]
                  .map((course) =>
                  DropdownMenuItem(value: course, child: Text(course)))
                  .toList(),
              onChanged: (value) => setState(() => selectedCourse = value),
              decoration: InputDecoration(
                labelText: "Select Course",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: selectedCourse,
            ),
            const SizedBox(height: 16),

            // Button for Day Picker
            InkWell(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDay == null
                          ? "Select Day"
                          : "${selectedDay!.day}/${selectedDay!.month}/${selectedDay!.year}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Button for Time Picker
            InkWell(
              onTap: pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedTime == null
                          ? "Select Time"
                          : selectedTime!.format(context),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.access_time, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  ColorsApp.primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TableformScreen()),
                    );
                  },
                  child: const Text(
                    'Create Table',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 35),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsApp.primary,
                  ),
                  onPressed: addCourse,
                  child: const Text(
                    'Add Course',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // List of Added Courses
            Expanded(
              child: ListView.builder(
                itemCount: tableData.length,
                itemBuilder: (context, index) {
                  final course = tableData[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: ColorsApp.primary,
                        child: Text(
                          course['course']![0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text("${course['course']}"),
                      subtitle: Text(
                          "Day: ${course['day']!.day}/${course['day']!.month}/${course['day']!.year}\nTime: ${course['time']!.format(context)}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

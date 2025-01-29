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
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final List<Map<String, dynamic>> tableData = [];
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
  Future<void> pickStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }
  Future<void> pickEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }

  void addCourse() {
    if (selectedCourse != null &&
        selectedDay != null &&
        startTime != null &&
        endTime != null) {
      setState(() {
        tableData.add({
          "course": selectedCourse!,
          "day": selectedDay!,
          "start_time": startTime!,
          "end_time": endTime!,
        });
        selectedCourse = null;
        selectedDay = null;
        startTime = null;
        endTime = null;
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
      backgroundColor: const Color(0xFFF7F9FC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Text(
                "Fill in the details to create your schedule",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              TextField(
                onChanged: (value) {
                  setState(() {
                    selectedCourse = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Enter Course Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              InkWell(
                onTap: pickStartTime,
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
                        startTime == null
                            ? "Select Start Time"
                            : startTime!.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.access_time, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: pickEndTime,
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
                        endTime == null
                            ? "Select End Time"
                            : endTime!.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.access_time, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsApp.primary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TableformScreen(),
                        ),
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

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
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
                            "Day: ${course['day']!.day}/${course['day']!.month}/${course['day']!.year}\nTime: ${course['start_time']!.format(context)} - ${course['end_time']!.format(context)}"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

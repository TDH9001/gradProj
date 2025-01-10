import 'package:flutter/material.dart';

import '../account/account_screen.dart';
import '../orgappbar.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedValue1;
  String? selectedValue2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(
        scaffoldKey: scaffoldKey,
        title: "About courses",
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: AccountScreen(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Dropdown for selecting Level
              DropdownButtonFormField<String>(
                items: [
                  "Level 1", "Level 2", "Level 3", "Level 4", "All Levels"
                ]
                    .map((level) =>
                    DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue1 = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Select Level",
                  hintText: "Choose Level",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                dropdownColor: Colors.white,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xff769BC6),
                ),
                value: selectedValue1,
                isExpanded: false, // لمنع أخذ القائمة عرض الحقل بالكامل
              ),
              SizedBox(height: 20),
              // Dropdown for selecting Semester
              DropdownButtonFormField<String>(
                items: [
                  "Semester 1", "Semester 2",
                ]
                    .map((semester) => DropdownMenuItem(
                  value: semester,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: Text(
                      semester,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue2 = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Select Semester",
                  hintText: "Choose Semester",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                dropdownColor: Colors.white,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xff769BC6),
                ),
                value: selectedValue2,
                isExpanded: false,
              ),
              
              SizedBox(height: 20),
              // Display selected values
              Text(
                "Selected Level: $selectedValue1",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Selected Semester: $selectedValue2",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

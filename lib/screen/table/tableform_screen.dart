import 'package:flutter/material.dart';
import 'package:grad_proj/screen/orgappbar.dart';

import '../../UI/colors.dart';

class TableformScreen extends StatelessWidget {
   TableformScreen({super.key});

  final List<Map<String, String>> schedule = [
    {'subject': 'math1', 'day': 'monday', 'time': '10:00 AM'},
    {'subject': 'math2', 'day': 'monday', 'time': '12:00 PM'},
    {'subject': 'math3', 'day': 'monday', 'time': '12:00 PM'},
    {'subject': 'math4', 'day': 'monday', 'time': '9:00 AM'},
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Orgappbar(scaffoldKey: scaffoldKey ,  title: "Table",
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 30,),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffA1C1E1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Header Row
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Courses Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold , )),
                        Text('Day', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                        Text('Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  // Divider
                  Divider(color:ColorsApp.primary, thickness: 1),
                  // Data Rows
                  for (var item in schedule)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(item['subject']!, style: TextStyle(fontSize: 16)),
                          Text(item['day']!, style: TextStyle(fontSize: 16)),
                          Text(item['time']!, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  SizedBox(height: 20), // Add space at the bottom
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
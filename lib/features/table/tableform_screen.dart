import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/sceduleitem.dart';
import 'package:provider/provider.dart';
import '../../widgets/orgappbar.dart';
import '../theme/theme_provider.dart';


class TableformScreen extends StatelessWidget {
  final List<Map<String, String>> courses = [
    {'course': 'Math 101', 'time': '10:00 AM - 12:00 PM', 'day': 'Monday'},
    {'course': 'Physics 201', 'time': '01:00 PM - 03:00 PM', 'day': 'Tuesday'},
    {'course': 'History 101', 'time': '09:00 AM - 11:00 AM', 'day': 'Wednesday'},
    {'course': 'Chemistry 202', 'time': '02:00 PM - 04:00 PM', 'day': 'Thursday'},
  ];

  TableformScreen({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(
        scaffoldKey: scaffoldKey,
        title: "Schedule Table",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Weekly Schedule',
              style: TextStyle(
                fontSize: 20,
                color:  isDarkMode ? Colors.white70 : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Sceduleitem(
                    title: course['course']!,
                    subtitle: course['day']!,
                    thirdText: course['time']!,
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

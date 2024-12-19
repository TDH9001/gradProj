import 'package:flutter/material.dart';
import 'package:grad_proj/screen/aboutscreens/level_screen.dart';
import 'package:grad_proj/screen/navbar_screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';

import 'component.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  static String id = "AboutScreen";

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(scaffoldKey: scaffoldKey),
      drawer: NavbarScreen(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            aboutButtonScreen(
              text: 'About Courses',
              onPressed: () {
                // print('hello sarah ');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LevelScreen()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            aboutButtonScreen(
              text: 'About Calculate Gpa',
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            aboutButtonScreen(
              text: 'About Computerscience',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

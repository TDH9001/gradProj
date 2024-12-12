import 'package:flutter/material.dart';
import 'package:grad_proj/screen/aboutbutton_screen.dart';
import 'package:grad_proj/screen/level_screen.dart';
import 'package:grad_proj/screen/navbar_screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';

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
            AboutbuttonScreen(
              text: 'About Courses',
              onpressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LevelScreen()));
              },
            ),
            SizedBox(
              height: 20,
            ),
            AboutbuttonScreen(
              text: 'About Calculate Gpa',
              onpressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            AboutbuttonScreen(
              text: 'About Computerscience',
              onpressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

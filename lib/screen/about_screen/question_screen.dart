import 'package:flutter/material.dart';
import 'package:grad_proj/screen/about_screen/Chatbot/chat_bot_screen.dart' show ChatBotScreen;


import 'package:grad_proj/screen/about_screen/courses_screen.dart';
import 'package:grad_proj/widgets/orgappbar.dart';
import '../../widgets/custom_card.dart';
import 'cs_screens/cs_screen.dart';
import 'gpa_screens/gpa_screen.dart';

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
      appBar: Orgappbar(
        scaffoldKey: scaffoldKey,
        title: " Questions",
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomCard(
              icon: Icons.question_answer,
              title: 'What courses are available?',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LevelScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomCard(
              icon: Icons.calculate,
              title: 'How can I calculate my GPA?',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  GpaScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomCard(
              icon: Icons.calculate,
              title: 'ChatBot',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ChatBotScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomCard(
              icon: Icons.computer,
              title: 'Why study Computer Science?',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  CsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

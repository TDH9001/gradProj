import 'package:flutter/material.dart';
import 'package:grad_proj/screen/about_screen/chatbot/chat_screen.dart';
import 'package:grad_proj/widgets/custom_container.dart';
import 'package:grad_proj/widgets/custom_scibutton.dart';
import 'package:grad_proj/widgets/orgappbar.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../theme/dark_theme_colors.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  static String id = "AboutScreen";//

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
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
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
        CustomContainer(
        child: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
          Text(
          'Welcome to Ain Shams University Faculty of Science Guide!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color: isDarkMode ? Colors.white : Colors.black),
        ),
        SizedBox(height: 10),
        Text(
          "I'm here to help you find the best courses and career paths "
              "for your studies at Ain Shams University. 🎓\n\n"
              "Would you like to start a conversation with our smart assistant?",
          style: TextStyle(fontSize: 16, color:isDarkMode ? Colors.white70 : Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        CustomScibutton(text: 'chat with sciMate', onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      },),
        SizedBox(height: 10),
        CustomScibutton(text: 'Cancel', onPressed: () {
        Navigator.pop(context);
      },),
          ],
        ),
    ),
            Positioned(
              top: -40,
              right: -15,
              child: CircleAvatar(
                radius: 30,
                child: CircleAvatar(
                  backgroundColor: isDarkMode? DarkThemeColors.secondary : Color(0xFF4A739F),
                  radius: 28,
                  backgroundImage: AssetImage('assets/images/robot.png'),
                ),
              ),
            ),
          ],
    ),
    ),
    );
  }
}

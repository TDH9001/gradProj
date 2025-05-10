import 'package:easy_localization/easy_localization.dart';
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
        title: 'Question.title'.tr(),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_forward , color: Colors.white,),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
        CustomContainer(
        child: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 80,),
          Text(
          'Question.welcome'.tr(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold ,color: isDarkMode ? Colors.white : Colors.black),
        ),
        SizedBox(height: 20),
        Text(
        'Question.body'.tr(),
          style: TextStyle(fontSize: 14, color:isDarkMode ? Colors.white70 : Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        CustomScibutton(text: 'Question.chat_button'.tr(), onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      },),
        SizedBox(height: 20),
        CustomScibutton(text: 'Question.cancel_button'.tr(), onPressed: () {
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

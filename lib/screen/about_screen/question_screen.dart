import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/about_screen/chatbot/chat_screen.dart';
import 'package:grad_proj/widgets/custom_container.dart';
import 'package:grad_proj/widgets/custom_scibutton.dart';
import 'package:grad_proj/widgets/orgappbar.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_provider.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});
  static String id = "AboutScreen";
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
      appBar: Orgappbar(scaffoldKey: scaffoldKey, title: " question_title".tr(),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white),
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
          'question_text1'.tr(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color: isDarkMode?Colors.white:Colors.black),
        ),
        SizedBox(height: 10),
        Text(
          "question_text2".tr(),
          style: TextStyle(fontSize: 16, color: isDarkMode?Colors.white60: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        CustomScibutton(text: 'question_scimate'.tr(), onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      },),
        SizedBox(height: 10),
        CustomScibutton(text: 'question_cancel'.tr(), onPressed: () {
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
                  backgroundColor: Color(0xffA3BFE0),
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

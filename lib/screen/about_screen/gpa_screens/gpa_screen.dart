
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/about_screen/gpa_screens/question_gpa.dart';
import 'package:grad_proj/screen/account/account_screen.dart';
import 'package:grad_proj/widgets/custom_card.dart';

import '../../../widgets/orgappbar.dart';

class GpaScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
   GpaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(scaffoldKey: scaffoldKey , title: "GPA",
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
      )),
      body: ListView(
        children: [
          CustomCard(icon: Icons.info, title: 'Problem Of GPA',  onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuestionGpa()),
            );
          })
        ],
      ),
      //drawer: AccountScreen(),


    );
  }
}

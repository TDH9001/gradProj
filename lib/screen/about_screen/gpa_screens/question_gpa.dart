import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/gpa_card_listview.dart';

import '../../../widgets/orgappbar.dart';

class QuestionGpa extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
   QuestionGpa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(
        scaffoldKey: scaffoldKey,
        title: " GPA",
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CardQuestionListview()
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/category_card.dart';

import '../models/question_model.dart';

class CsListview extends StatelessWidget {
  final List<QuestionModel> questions =
  [
    QuestionModel(question:'what  is computer science' , answer: 'that is '),
    QuestionModel(question:'How important is computer science ' , answer: 'that is '),
    QuestionModel(question:'huoshcuhdvud  ' , answer: 'that is '),

  ];
  CsListview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return  QuestionCard(question: questions[index],);
      },
    );
  }
}

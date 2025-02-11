import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/category_card.dart';

import '../models/question_model.dart';

class CardQuestionListview extends StatelessWidget {
  final List<QuestionModel> questions =
  [
    QuestionModel(question:'what gpa ' , answer: 'that is '),
    QuestionModel(question:'what gpa ' , answer: 'that is '),
    QuestionModel(question:'what gpa ' , answer: 'that is '),

  ];
 CardQuestionListview({super.key});

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

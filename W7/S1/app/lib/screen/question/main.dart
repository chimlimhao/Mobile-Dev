import 'package:flutter/material.dart';
import 'package:app/model/quiz.dart';
import 'package:app/screen/question/answerCard.dart';
import 'card.dart';

class QuestionScreen extends StatelessWidget {
  final Question question;
  final Function(String) submitAnswer;
  const QuestionScreen(
      {super.key, required this.question, required this.submitAnswer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 44),
            QuestionCard(question: question),
            const SizedBox(height: 44),
            for (var item in question.possibleAnswers)
              Answercard(
                possibleAnswer: item,
                trigger: submitAnswer,
              ),
          ],
        ),
      ),
    );
  }
}

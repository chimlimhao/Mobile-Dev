import 'package:flutter/material.dart';
import 'package:app/model/quiz.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              question.title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

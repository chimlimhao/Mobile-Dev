import 'package:flutter/material.dart';
import 'package:app/model/submission.dart';

class CorrectCard extends StatelessWidget {
  final Answer answer;
  const CorrectCard({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    Color backGround =
        answer.isCorrect() ? const Color(0xFFE6F4EA) : const Color(0xFFFDECEA);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: backGround,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Title
              Text(
                answer.question.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              ...answer.question.possibleAnswers.map((option) {
                bool isCorrectAnswer = option == answer.question.goodAnswer;
                bool isSelectedAnswer = option == answer.questionsAnswer;

                Color textColor = isCorrectAnswer
                    ? Colors.green
                    : isSelectedAnswer
                        ? Colors.red
                        : Colors.black;

                Icon? trailingIcon = isCorrectAnswer
                    ? const Icon(Icons.check, color: Colors.green)
                    : isSelectedAnswer
                        ? const Icon(Icons.close, color: Colors.red)
                        : null;

                return Column(
                  children: [
                    ListTile(
                      trailing: trailingIcon,
                      title: Text(
                        option,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:app/model/quiz.dart';
import 'package:app/model/submission.dart';
import 'package:app/screen/result/restartButton.dart';
import '../result/correctionCard.dart';

class ResultScreen extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onRestart;
  final Submission submit;
  const ResultScreen(
      {super.key,
      required this.submit,
      required this.onRestart,
      required this.quiz});

  @override
  Widget build(BuildContext context) {
    final int score = submit.getScore();
    final int fullscore = submit.answerList.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 44),
                child: Text(
                  "$score / $fullscore Score",
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              for (int i = 0; i < submit.answerList.length; i++)
                CorrectCard(
                  answer: submit.answerList[i],
                ),
              const SizedBox(
                height: 120,
              ),
              Restartbutton(trigger: onRestart),
              const SizedBox(
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

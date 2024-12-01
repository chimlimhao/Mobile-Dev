import 'package:flutter/material.dart';
import 'package:app/model/submission.dart';
import 'model/quiz.dart';
import 'package:app/screen/welcome/main.dart';
import 'package:app/screen/question/main.dart';
import 'package:app/screen/result/main.dart';

enum Pages {
  notStarted,
  started,
  finished;
}

Color appColor = Colors.blue[500] as Color;

class QuizApp extends StatefulWidget {
  final Quiz quiz;
  const QuizApp({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  Pages quizState = Pages.notStarted;
  Submission submit = Submission();
  int currentIndex = 0;

  void submitAnswer(String answer) {
    Answer asAnswer = Answer(
      question: widget.quiz.questions[currentIndex],
      questionsAnswer: answer,
    );
    submit.addAnswer(asAnswer);
    setState(() {
      if (currentIndex < widget.quiz.questions.length - 1) {
        currentIndex++;
      } else {
        switchPage(Pages.finished);
      }
    });
  }

  void switchPage(Pages page) {
    setState(() {
      quizState = page;
    });
  }

  void onRestart() {
    submit.removeAnswer();
    setState(() {
      quizState = Pages.notStarted;
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (quizState) {
      case Pages.notStarted:
        return WelcomeScreen(title: widget.quiz.title, onStart: switchPage);
      case Pages.started:
        return QuestionScreen(
            question: widget.quiz.questions[currentIndex],
            submitAnswer: submitAnswer);
      case Pages.finished:
        return ResultScreen(
          onRestart: onRestart,
          submit: submit,
          quiz: widget.quiz,
        );
      default:
        return WelcomeScreen(title: widget.quiz.title, onStart: switchPage);
    }
  }
}

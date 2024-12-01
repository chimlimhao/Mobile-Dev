import 'package:flutter/material.dart';
import 'package:app/data/dataProvider.dart';
import 'package:app/quiz_app.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizApp(
      quiz: game1,
    );
  }
}

// void main() {

//   Question q1 = const Question(
//       title: "Who is the best teacher?",
//       possibleAnswers: ["ronan", "hongly", 'leangsiv'],
//       goodAnswer: 'ronan');
//   Question q2 = const Question(
//       title: "Which color is the best?",
//       possibleAnswers: ["blue", "red", 'green'],
//       goodAnswer: 'red');

//   List<Question> myQuestions = [q1, q2];
//   Quiz myQuiz = Quiz(title: "Crazy Quizz", questions: myQuestions);

//   runApp(QuizApp(myQuiz));
// }
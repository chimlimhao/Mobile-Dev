import 'package:app/model/quiz.dart';

Quiz game1 = Quiz(
  title: "Flutter Quiz",
  questions: questionList,
);

List<Question> questionList = [
  const Question(
    title: "What is Flutter?",
    possibleAnswers: [
      "A programming language",
      "A UI framework",
      "A database engine"
    ],
    goodAnswer: "A UI framework",
  ),
  const Question(
    title: "Which programming language is used in Flutter?",
    possibleAnswers: ["Java", "C++", "Dart"],
    goodAnswer: "Dart",
  ),
  const Question(
    title: "Which widget is used for a simple button in Flutter?",
    possibleAnswers: ["TextButton", "RaisedButton", "FlatButton"],
    goodAnswer: "TextButton",
  ),
  const Question(
    title: "Which command is used to create a new Flutter project?",
    possibleAnswers: ["flutter create", "flutter new", "flutter start"],
    goodAnswer: "flutter create",
  ),
  const Question(
    title: "What does 'StatelessWidget' mean in Flutter?",
    possibleAnswers: [
      "Widget with mutable state",
      "Widget without mutable state",
      "A widget that animates"
    ],
    goodAnswer: "Widget without mutable state",
  ),
  const Question(
    title: "Which widget is used to display an image in Flutter?",
    possibleAnswers: ["Image", "Icon", "Picture"],
    goodAnswer: "Image",
  ),
];

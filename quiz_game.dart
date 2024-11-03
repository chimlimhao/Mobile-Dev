import 'dart:io';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class QuizGame {
  // Private attributes
  final String _apiKey;
  String _playerName = '';
  Difficulty _currentDifficulty = Difficulty.beginner;
  int _score = 0;
  final Map<Difficulty, List<Question>> _questionBank = {};

  // Constructor
  QuizGame({required String apiKey}) : _apiKey = apiKey;

  // Getters
  String get playerName => _playerName;
  Difficulty get currentDifficulty => _currentDifficulty;
  int get score => _score;

  // Methods
  void clearScreen() {
    print('\x1B[2J\x1B[0;0H');
    stdout.write('\x1B[H\x1B[2J');
  }

  void getPlayerName() {
    print('Welcome to the Flutter Quiz Game!');
    stdout.write('Enter your name: ');
    _playerName = stdin.readLineSync() ?? '';
  }

  void displayMenu() {
    print('=== Quiz Game Menu ===');
    print('Welcome, $_playerName!');
    print('1. Play');
    print('2. Set Difficulty');
    print('3. Exit');
  }

  void setDifficulty() {
    clearScreen();
    print('Select Difficulty:');
    print('1. Beginner (3 lives)');
    print('2. Intermediate (2 lives)');
    print('3. Advanced (1 life)');
    stdout.write('Enter your choice: ');

    String choice = stdin.readLineSync() ?? '';
    switch (choice) {
      case '1':
        _currentDifficulty = Difficulty.beginner;
      case '2':
        _currentDifficulty = Difficulty.intermediate;
      case '3':
        _currentDifficulty = Difficulty.advanced;
      default:
        _currentDifficulty = Difficulty.beginner;
    }
  }

  Future<List<Question>> generateQuestions() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
    final prompt = '''
      Generate 10 Flutter programming multiple choice questions for ${_currentDifficulty.name} level.
      Return ONLY a JSON array with no additional text or formatting.
      
      Requirements:
      - Correct answers should be randomly distributed (not always the same position)
      - correctAnswer should be a number between 1 and 4
      - Make sure the correct answer actually matches the right option
      
      Format example:
      [
        {
          "question": "What is a StatelessWidget in Flutter?",
          "options": [
            "A widget that can change state",
            "A widget that never changes",
            "A database widget",
            "A testing widget"
          ],
          "correctAnswer": 2
        }
      ]
    ''';

    try {
      final content = Content.text(prompt);
      final response = await model.generateContent([content]);
      String jsonString = response.text?.trim() ?? '[]';

      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }
      jsonString = jsonString.trim();

      final List<dynamic> questionsJson = json.decode(jsonString);
      if (questionsJson.isEmpty) {
        print('No questions generated');
      }

      return questionsJson
          .map((q) => Question(
                q['question'],
                List<String>.from(q['options']),
                q['correctAnswer'],
              ))
          .toList();
    } catch (e) {
      print('Error generating questions: $e');
      throw e;
    }
  }

  Future<void> playQuiz() async {
    clearScreen();
    _score = 0;
    int currentLives = _currentDifficulty.lives;

    List<Question> questions =
        _questionBank[_currentDifficulty] ?? await generateQuestions();
    _questionBank[_currentDifficulty] = questions;

    for (int i = 0; i < questions.length; i++) {
      if (currentLives <= 0) break;

      Question question = questions[i];
      print('\n=== Question ${i + 1}/${questions.length} ===');
      print('Lives: $currentLives | Score: $_score');
      print('\n${question.question}');

      for (int j = 0; j < question.options.length; j++) {
        print('${j + 1}. ${question.options[j]}');
      }

      stdout.write('\nYour answer (1-4): ');
      String? answer = stdin.readLineSync();

      if (answer != null && int.tryParse(answer) == question.correctAnswer) {
        print('\n✓ Correct!');
        _score++;
      } else {
        print('\n✗ Wrong! Correct answer was: ${question.correctAnswer}');
        currentLives--;
        print('Lives remaining: $currentLives');
      }

      stdout.write('\nPress Enter to continue...');
      stdin.readLineSync();
      clearScreen();
    }

    print('\n=== Final Results ===');
    print('Score: $_score/${questions.length}');
    if (_score < 5) {
      print('You need to score at least 5 to pass!');
    } else {
      print('Congratulation! You have passed the quiz.');
    }
    stdout.write('Press Enter to return to menu...');
    stdin.readLineSync();
  }

  Future<void> startGame() async {
    while (true) {
      clearScreen();
      displayMenu();
      stdout.write('Enter your choice: ');
      String choice = stdin.readLineSync() ?? '';

      switch (choice) {
        case '1':
          await playQuiz();
        case '2':
          setDifficulty();
        case '3':
          return;
      }
    }
  }

  Future<void> run() async {
    clearScreen();
    getPlayerName();
    await startGame();
    print('Thanks for playing, $_playerName!');
  }
}

// Keep these outside the class
enum Difficulty {
  beginner(lives: 3),
  intermediate(lives: 2),
  advanced(lives: 1);

  final int lives;
  const Difficulty({required this.lives});
}

class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;

  Question(this.question, this.options, this.correctAnswer);
}

void main() async {
  final apiKey = const String.fromEnvironment('GEMINI_API_KEY',
      defaultValue: 'AIzaSyD1ZduNu_jtY5pZq3T67QHGKLaAltIItWI');

  final game = QuizGame(apiKey: apiKey);
  await game.run();
}

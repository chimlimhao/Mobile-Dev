import 'dart:io';

// Enums
enum Difficulty {
  beginner(lives: 3),
  intermediate(lives: 2),
  advanced(lives: 1);

  final int lives;
  const Difficulty({required this.lives});
}

// Models
class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;

  Question(this.question, this.options, this.correctAnswer);

  // Static method to get questions by difficulty
  static Map<Difficulty, List<Question>> getQuestionBank() {
    return {
      Difficulty.beginner: _beginnerQuestions,
      Difficulty.intermediate: _intermediateQuestions,
      Difficulty.advanced: _advancedQuestions,
    };
  }

  // Private static lists of questions by difficulty
  static final List<Question> _beginnerQuestions = [
    Question("What widget should you use to create a clickable button?",
        ["Container", "ElevatedButton", "Text", "Image"], 2),
    Question("Which widget is used to create a scrollable list of widgets?",
        ["Row", "Column", "ListView", "Stack"], 3),
    Question("What is the main widget in a Flutter app?",
        ["MaterialApp", "Scaffold", "AppBar", "Container"], 1),
  ];

  static final List<Question> _intermediateQuestions = [
    Question(
        "What is the purpose of setState()?",
        [
          "To navigate between screens",
          "To update the UI",
          "To store data",
          "To make HTTP requests"
        ],
        2),
    Question("Which widget is used for creating a grid layout?",
        ["GridView", "ListView", "Column", "Row"], 1),
    Question(
        "What is a StatefulWidget?",
        [
          "A widget that never changes",
          "A widget that can be modified by parent",
          "A widget that can change state",
          "A widget for animations only"
        ],
        3),
  ];

  static final List<Question> _advancedQuestions = [
    Question(
        "What is the BuildContext in Flutter?",
        [
          "A widget's location in the widget tree",
          "A build configuration",
          "A type of widget",
          "A build method"
        ],
        1),
    Question("Which state management solution is built into Flutter?",
        ["GetX", "Bloc", "Provider", "setState"], 4),
    Question(
        "What is the purpose of the Key parameter in widgets?",
        [
          "For styling",
          "For animations",
          "For unique identification and state preservation",
          "For layout constraints"
        ],
        3),
  ];
}

// Game State Management
class GameState {
  String playerName;
  Difficulty currentDifficulty;
  int score;
  final Map<Difficulty, List<Question>> questionBank;

  GameState({
    this.playerName = '',
    this.currentDifficulty = Difficulty.beginner,
    this.score = 0,
    Map<Difficulty, List<Question>>? questionBank,
  }) : questionBank = questionBank ?? Question.getQuestionBank();

  void resetScore() {
    score = 0;
  }

  void updateDifficulty(Difficulty difficulty) {
    currentDifficulty = difficulty;
  }

  void incrementScore() {
    score++;
  }
}

// UI Management
class ConsoleUI {
  static void clearScreen() {
    print('\x1B[2J\x1B[0;0H');
    stdout.write('\x1B[H\x1B[2J');
  }

  static void displayMenu(String playerName) {
    print('=== Quiz Game Menu ===');
    print('Welcome, $playerName!');
    print('1. Play');
    print('2. Set Difficulty');
    print('3. Exit');
  }

  static void displayDifficultyMenu() {
    print('Select Difficulty:');
    print('1. Beginner (3 lives)');
    print('2. Intermediate (2 lives)');
    print('3. Advanced (1 life)');
  }

  static String? getInput(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync();
  }

  static void waitForEnter() {
    stdout.write('Press Enter to continue...');
    stdin.readLineSync();
  }

  static void displayQuestion(Question question, int questionNumber,
      int totalQuestions, int lives, int score) {
    print('\n=== Question $questionNumber/$totalQuestions ===');
    print('Lives: $lives | Score: $score');
    print('\n${question.question}');

    for (int i = 0; i < question.options.length; i++) {
      print('${i + 1}. ${question.options[i]}');
    }
  }

  static void displayResults(int score, int totalQuestions, bool passed) {
    print('\n=== Final Results ===');
    print('Score: $score/$totalQuestions');
    if (passed) {
      print('Congratulations! You have passed the quiz.');
    } else {
      print('You need to score at least 2 to pass!');
    }
  }
}

// Main Game Logic
class QuizGame {
  final GameState _gameState;

  QuizGame() : _gameState = GameState();

  void getPlayerName() {
    ConsoleUI.clearScreen();
    _gameState.playerName = ConsoleUI.getInput('Enter your name: ') ?? '';
  }

  void setDifficulty() {
    ConsoleUI.clearScreen();
    ConsoleUI.displayDifficultyMenu();

    String choice = ConsoleUI.getInput('Enter your choice: ') ?? '';
    switch (choice) {
      case '1':
        _gameState.updateDifficulty(Difficulty.beginner);
      case '2':
        _gameState.updateDifficulty(Difficulty.intermediate);
      case '3':
        _gameState.updateDifficulty(Difficulty.advanced);
      default:
        _gameState.updateDifficulty(Difficulty.beginner);
    }
  }

  Future<void> playQuiz() async {
    ConsoleUI.clearScreen();
    _gameState.resetScore();
    int currentLives = _gameState.currentDifficulty.lives;

    List<Question> questions =
        _gameState.questionBank[_gameState.currentDifficulty]!;

    for (int i = 0; i < questions.length && currentLives > 0; i++) {
      Question question = questions[i];
      ConsoleUI.displayQuestion(
          question, i + 1, questions.length, currentLives, _gameState.score);

      String? answer = ConsoleUI.getInput('\nYour answer (1-4): ');

      if (answer != null && int.tryParse(answer) == question.correctAnswer) {
        print('\n✓ Correct!');
        _gameState.incrementScore();
      } else {
        print('\n✗ Wrong! Correct answer was: ${question.correctAnswer}');
        currentLives--;
        print('Lives remaining: $currentLives');
      }

      ConsoleUI.waitForEnter();
      ConsoleUI.clearScreen();
    }

    ConsoleUI.displayResults(
        _gameState.score, questions.length, _gameState.score >= 2);
    ConsoleUI.waitForEnter();
  }

  Future<void> startGame() async {
    while (true) {
      ConsoleUI.clearScreen();
      ConsoleUI.displayMenu(_gameState.playerName);
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
    ConsoleUI.clearScreen();
    getPlayerName();
    await startGame();
    print('Thanks for playing, ${_gameState.playerName}!');
  }
}

void main() async {
  final game = QuizGame();
  await game.run();
}

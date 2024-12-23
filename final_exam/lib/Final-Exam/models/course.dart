import 'student_score.dart';

class Course {
  final String name;
  final List<StudentScore> scores;

  const Course({required this.name, this.scores = const []});

  double get averageScore {
    if (scores.isEmpty) {
      return 0;
    }
    return scores.fold(0.0, (sum, score) => sum + score.score) / scores.length;
  }
}

import '../models/course.dart';
import '../models/student_score.dart';

// Dummy data for testing
final dummyData = [
  Course(
    name: 'HTML',
    scores: [
      StudentScore(name: 'Lionel Messi', score: 25),
      StudentScore(name: 'Suarez', score: 40),
      StudentScore(name: 'Neymar Jr', score: 85),
    ],
  ),
  const Course(
    name: 'JAVA',
    scores: [],
  ),
];

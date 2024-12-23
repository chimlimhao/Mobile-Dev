import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/student_score.dart';
import 'score_form.dart';

class CourseDetail extends StatefulWidget {
  final Course item;
  final Function(Course) onCourseUpdated;

  const CourseDetail({
    super.key,
    required this.item,
    required this.onCourseUpdated,
  });

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  late List<StudentScore> _scores;

  @override
  void initState() {
    super.initState();
    _scores = List.from(widget.item.scores);
  }

  Color _getScoreColor(double score) {
    if (score > 50) return Colors.green;
    if (score >= 30) return Colors.orange;
    return Colors.red;
  }

  void _showAddScoreForm(StudentScore student) {
    setState(() {
      _scores.add(student);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ScoreForm(onScoreAdded: _showAddScoreForm),
                  ),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _scores.isEmpty
                ? const Center(child: Text('No scores'))
                : ListView.builder(
                    itemCount: _scores.length,
                    itemBuilder: (context, index) {
                      final score = _scores[index];
                      return ListTile(
                        title: Text(score.name),
                        trailing: Text(
                          score.score.toString(),
                          style: TextStyle(
                            color: _getScoreColor(score.score),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/course.dart';
import 'course_view.dart';
import '../data/dummy_data.dart';
// import '../widgets/course_view.dart';

class CourseView extends StatefulWidget {
  const CourseView({super.key});

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  final List<Course> _courseList = List.from(dummyData);

  void handleCoursePressed(Course course) {
    setState(() {
      final index = _courseList.indexWhere((i) => i.name == course.name);
      if (index != -1) {
        _courseList[index] = course;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SCORE APP'),
        ),
        body: ListView.builder(
          itemCount: _courseList.length,
          itemBuilder: (context, index) {
            final course = _courseList[index];
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Text(course.name),
                subtitle: course.scores.isEmpty
                    ? const Text('No score')
                    : Text(
                        '${course.scores.length} scores\nAverage: ${course.averageScore.toStringAsFixed(1)}',
                      ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => CourseDetail(
                            item: course,
                            onCourseUpdated: (updatedCourse) {
                              setState(() {
                                _courseList[index] = updatedCourse;
                              });
                            })),
                  );
                },
              ),
              // const SizedBox(height: 12,);
            );
          },
        ));
  }
}

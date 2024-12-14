import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';

class ApplicationsScreen extends StatelessWidget {
  final List<Job> appliedJobs; // List of applied jobs

  const ApplicationsScreen({required this.appliedJobs, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appliedJobs.length,
        itemBuilder: (context, index) {
          final job = appliedJobs[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text(job.company),
          );
        },
      ),
    );
  }
}

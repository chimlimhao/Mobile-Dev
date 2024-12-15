import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';

class ApplicationsScreen extends StatelessWidget {
  final List<Job> appliedJobs; // List of applied jobs

  const ApplicationsScreen({required this.appliedJobs, super.key});

  @override
  Widget build(BuildContext context) {
    if (appliedJobs.isEmpty) {
      return const Center(child: Text('No applications yet'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Application',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appliedJobs.length,
        itemBuilder: (context, index) {
          final job = appliedJobs[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text(job.company),
            trailing: const Text('Applied'),
            onTap: () {},
          );
        },
      ),
    );
  }
}

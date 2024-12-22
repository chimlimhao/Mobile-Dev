import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'auth_service.dart';

class ApplicationService {
  static const String _appliedJobsKey = 'applied_jobs';
  static SharedPreferences? _prefs;

  // Initialize shared preferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get list of applied jobs for current user
  static List<Job> getAppliedJobs() {
    final user = AuthService.getCurrentUser();
    if (user == null || _prefs == null) return [];

    final appliedJobsJson = _prefs!.getString('${_appliedJobsKey}_${user.id}') ?? '[]';
    final List<dynamic> jobsList = json.decode(appliedJobsJson);
    return jobsList.map((json) => Job.fromJson(json)).toList();
  }

  // Save applied job with status
  static Future<void> _saveAppliedJob(Job job, String status) async {
    final user = AuthService.getCurrentUser();
    if (user == null || _prefs == null) return;

    final appliedJobs = getAppliedJobs();
    if (!appliedJobs.any((j) => j.id == job.id)) {
      final jobWithStatus = {
        ...job.toJson(),
        'applicationStatus': status,
        'appliedDate': DateTime.now().toIso8601String(),
      };
      
      final jobs = [...appliedJobs.map((j) => j.toJson()), jobWithStatus];
      await _prefs!.setString('${_appliedJobsKey}_${user.id}', json.encode(jobs));
    }
  }

  static Future<void> applyToJob(BuildContext context, Job job, {Function? onApplicationComplete}) async {
    final user = AuthService.getCurrentUser();
    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to apply for jobs'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Show application confirmation dialog
    if (context.mounted) {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Start Application Process'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Job: ${job.title}'),
                Text('Company: ${job.company}'),
                const SizedBox(height: 16),
                const Text('How it works:'),
                const SizedBox(height: 8),
                const Text('1. We\'ll open your email app with a pre-filled application'),
                const Text('2. Review and send the email when ready'),
                const Text('3. Come back and confirm when you\'ve sent it'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Start Application'),
              ),
            ],
          );
        },
      );

      if (confirmed != true) return;
    }

    final emailSubject = 'Application for ${job.title} position at ${job.company}';
    final emailBody = '''
Dear Hiring Manager,

I am writing to express my interest in the ${job.title} position at ${job.company}. I found this opportunity through JobGlide and I am excited about the possibility of joining your team.

I am ${user.preferences.profession} with experience in the field. Based on the job requirements, I believe my skills and experience make me a strong candidate for this role.

${job.applicationMethod.instructions ?? ''}

Thank you for considering my application. I look forward to discussing how I can contribute to ${job.company}.

Best regards,
${user.name}
''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: job.applicationMethod.value,
      query: 'subject=${Uri.encodeComponent(emailSubject)}&body=${Uri.encodeComponent(emailBody)}',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        
        // Mark as "In Progress" initially
        await _saveAppliedJob(job, 'In Progress');
        
        // Show confirmation dialog after email client opens
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Application'),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Did you send the application email?'),
                    SizedBox(height: 8),
                    Text('Please confirm only after you\'ve actually sent the email.'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Update status to "Not Sent"
                      _saveAppliedJob(job, 'Not Sent');
                      onApplicationComplete?.call(false);
                    },
                    child: const Text('No, I\'ll do it later'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Update status to "Applied"
                      _saveAppliedJob(job, 'Applied');
                      onApplicationComplete?.call(true);
                      // Show success message
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Application marked as sent! View it in your Applications tab.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text('Yes, I Sent It'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open email client. Please make sure you have an email app installed.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

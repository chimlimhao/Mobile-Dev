import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  static Future<void> applyToJob(
    BuildContext context,
    Job job, {
    required Function(bool) onApplicationComplete,
  }) async {
    final user = AuthService.getCurrentUser();
    
    // Check if user is logged in
    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to apply for jobs'),
            backgroundColor: Colors.red,
          ),
        );
        onApplicationComplete(false);
      }
      return;
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: job.applicationMethod.value,
      queryParameters: {
        'subject': 'Application for ${job.title} position at ${job.company}',
        'body': '''
Dear Hiring Manager,

I am writing to express my interest in the ${job.title} position at ${job.company}. I found this opportunity through JobGlide and I am excited about the possibility of joining your team.

I am ${user.preferences?.profession ?? 'a professional'} with experience in the field. Based on the job requirements, I believe my skills and experience make me a strong candidate for this role.

${job.applicationMethod.instructions ?? ''}

Best regards,
${user.name ?? 'Applicant'}
''',
      },
    );

    try {
      await launchUrl(emailLaunchUri);
      
      // Show confirmation dialog after email is launched
      if (context.mounted) {
        showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Application'),
              content: const Text('Did you send the application email?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    onApplicationComplete(false);
                    Navigator.of(context).pop();
                    _saveAppliedJob(job, 'Not Sent');
                  },
                ),
                TextButton(
                  child: const Text('Yes, I sent it'),
                  onPressed: () {
                    onApplicationComplete(true);
                    Navigator.of(context).pop();
                    _saveAppliedJob(job, 'Applied');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Application marked as sent! View it in your Applications tab.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch email application'),
            backgroundColor: Colors.red,
          ),
        );
        onApplicationComplete(false);
      }
    }
  }

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
}

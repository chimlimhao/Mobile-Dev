import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model.dart';
import 'auth_service.dart';
import 'email_service.dart';

class ApplicationService {
  static const String _savedJobsKey = 'saved_jobs';
  static const String _appliedJobsKey = 'applied_jobs';
  static const String _rejectedJobsKey = 'rejected_jobs';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> applyToJob(Job job) async {
    final user = AuthService.getCurrentUser();
    if (user == null) return false;

    // Send the application email
    final emailSent = await EmailService.sendJobApplication(
      user: user,
      job: job,
    );

    if (emailSent) {
      await _saveJobToList(job, _appliedJobsKey, JobStatus.applied);
      return true;
    }
    return false;
  }

  static Future<void> saveJob(Job job) async {
    await _saveJobToList(job, _savedJobsKey, JobStatus.saved);
  }

  static Future<void> rejectJob(Job job) async {
    await _saveJobToList(job, _rejectedJobsKey, JobStatus.rejected);
  }

  static Future<void> deleteJob(Job job, JobStatus status) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    final user = AuthService.getCurrentUser();
    if (user == null) return;

    final key = status == JobStatus.saved ? _savedJobsKey : _appliedJobsKey;
    final userKey = '${key}_${user.id}';
    
    // Get existing jobs
    final jobsJson = _prefs!.getString(userKey) ?? '[]';
    final List<dynamic> jobs = json.decode(jobsJson);
    
    // Remove the job with matching id
    final updatedJobs = jobs.where((j) => j['id'] != job.id).toList();
    
    // Save back to preferences
    await _prefs!.setString(userKey, json.encode(updatedJobs));

    // Check if job is already in rejected list
    final rejectedJobs = await getRejectedJobs();
    if (!rejectedJobs.any((j) => j.id == job.id)) {
      // Add to rejected jobs only if not already there
      await rejectJob(job);
    }
  }

  static Future<void> _saveJobToList(Job job, String key, JobStatus status) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    final user = AuthService.getCurrentUser();
    if (user == null) return;

    final userKey = '${key}_${user.id}';
    
    // Get existing jobs from all lists to check for duplicates
    final savedJobs = await getSavedJobs();
    final appliedJobs = await getAppliedJobs();
    final rejectedJobs = await getRejectedJobs();
    
    // Remove job from other lists if it exists
    if (key != _savedJobsKey && savedJobs.any((j) => j.id == job.id)) {
      await deleteJob(job, JobStatus.saved);
    }
    if (key != _appliedJobsKey && appliedJobs.any((j) => j.id == job.id)) {
      await deleteJob(job, JobStatus.applied);
    }
    if (key != _rejectedJobsKey && rejectedJobs.any((j) => j.id == job.id)) {
      // Remove from rejected list
      final rejectedKey = '${_rejectedJobsKey}_${user.id}';
      final rejectedJobsJson = _prefs!.getString(rejectedKey) ?? '[]';
      final List<dynamic> rejectedJobsList = json.decode(rejectedJobsJson);
      final updatedRejectedJobs = rejectedJobsList.where((j) => j['id'] != job.id).toList();
      await _prefs!.setString(rejectedKey, json.encode(updatedRejectedJobs));
    }

    // Get current list jobs
    final jobsJson = _prefs!.getString(userKey) ?? '[]';
    final List<dynamic> jobs = json.decode(jobsJson);
    
    // Add new job if not already in this list
    if (!jobs.any((j) => j['id'] == job.id)) {
      final jobJson = {
        ...job.toJson(),
        'isRemote': job.isRemote,
        'profession': job.profession,
        'postedDate': job.postedDate.toIso8601String(),
        'status': status.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      jobs.add(jobJson);

      // Save back to preferences
      await _prefs!.setString(userKey, json.encode(jobs));
    }
  }

  static Future<void> restoreJob(Job job) async {
    // First remove from rejected list
    final user = AuthService.getCurrentUser();
    if (user == null) return;

    final rejectedKey = '${_rejectedJobsKey}_${user.id}';
    final rejectedJobsJson = _prefs!.getString(rejectedKey) ?? '[]';
    final List<dynamic> rejectedJobs = json.decode(rejectedJobsJson);
    final updatedRejectedJobs = rejectedJobs.where((j) => j['id'] != job.id).toList();
    await _prefs!.setString(rejectedKey, json.encode(updatedRejectedJobs));

    // Then add to saved list
    await saveJob(job);
  }

  static Future<List<Job>> getSavedJobs() async {
    return _getJobsFromList(_savedJobsKey);
  }

  static Future<List<Job>> getAppliedJobs() async {
    return _getJobsFromList(_appliedJobsKey);
  }

  static Future<List<Job>> getRejectedJobs() async {
    return _getJobsFromList(_rejectedJobsKey);
  }

  static Future<List<Job>> _getJobsFromList(String key) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    final user = AuthService.getCurrentUser();
    if (user == null) return [];

    final userKey = '${key}_${user.id}';
    final jobsJson = _prefs!.getString(userKey) ?? '[]';
    final List<dynamic> jobs = json.decode(jobsJson);
    
    return jobs.map((jobJson) {
      // Ensure all required fields have default values
      final Map<String, dynamic> safeJson = {
        'id': jobJson['id'] ?? 'unknown',
        'title': jobJson['title'] ?? 'Unknown Job',
        'company': jobJson['company'] ?? 'Unknown Company',
        'location': jobJson['location'] ?? 'Remote',
        'description': jobJson['description'] ?? 'No description available',
        'requirements': jobJson['requirements'] ?? [],
        'jobType': jobJson['jobType'] ?? JobType.fullTime.toString(),
        'isRemote': jobJson['isRemote'] ?? false,
        'profession': jobJson['profession'] ?? 'Unknown',
        'salary': jobJson['salary'] ?? 'Competitive',
        'postedDate': jobJson['postedDate'] ?? DateTime.now().toIso8601String(),
        'applicationMethod': jobJson['applicationMethod'] ?? {
          'type': 'email',
          'value': 'unknown@example.com',
        },
        'companyWebsite': jobJson['companyWebsite'],
        'status': jobJson['status'],
        'timestamp': jobJson['timestamp'],
      };
      return Job.fromJson(safeJson);
    }).toList();
  }
}

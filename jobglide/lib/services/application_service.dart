import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'auth_service.dart';
import 'email_service.dart';
import '../data/dummy_data.dart';

class ApplicationService {
  static const String _savedJobsKey = 'saved_jobs';
  static const String _appliedJobsKey = 'applied_jobs';
  static const String _rejectedJobsKey = 'rejected_jobs';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> applyToJob(Job job) async {
    // First check if job is already saved or applied
    final savedJobs = await getSavedJobs();
    final appliedJobs = await getAppliedJobs();
    final rejectedJobs = await getRejectedJobs();

    if (appliedJobs.any((j) => j.id == job.id) ||
        rejectedJobs.any((j) => j.id == job.id)) {
      return false; // Job already applied or rejected
    }

    final user = AuthService.getCurrentUser();

    // Send the application email
    final emailSent = await EmailService.sendJobApplication(
      user: user,
      job: job,
    );

    if (emailSent) {
      // Remove from saved if it was there
      if (savedJobs.any((j) => j.id == job.id)) {
        await deleteJob(job, JobStatus.saved);
      }
      await _saveJobToList(job, _appliedJobsKey, JobStatus.applied);
      return true;
    }
    return false;
  }

  static Future<bool> saveJob(Job job) async {
    // First check if job is already saved or applied
    final savedJobs = await getSavedJobs();
    final appliedJobs = await getAppliedJobs();
    final rejectedJobs = await getRejectedJobs();

    if (savedJobs.any((j) => j.id == job.id) ||
        appliedJobs.any((j) => j.id == job.id) ||
        rejectedJobs.any((j) => j.id == job.id)) {
      return false; // Job already exists in one of the lists
    }

    await _saveJobToList(job, _savedJobsKey, JobStatus.saved);
    return true;
  }

  static Future<void> rejectJob(Job job) async {
    await _saveJobToList(job, _rejectedJobsKey, JobStatus.rejected);
  }

  static Future<void> deleteJob(Job job, JobStatus status) async {
    _prefs ??= await SharedPreferences.getInstance();

    final user = AuthService.getCurrentUser();

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

  static Future<void> _saveJobToList(
      Job job, String key, JobStatus status) async {
    _prefs ??= await SharedPreferences.getInstance();

    final user = AuthService.getCurrentUser();

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
      final updatedRejectedJobs =
          rejectedJobsList.where((j) => j['id'] != job.id).toList();
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

    final rejectedKey = '${_rejectedJobsKey}_${user.id}';
    final rejectedJobsJson = _prefs!.getString(rejectedKey) ?? '[]';
    final List<dynamic> rejectedJobs = json.decode(rejectedJobsJson);
    final updatedRejectedJobs =
        rejectedJobs.where((j) => j['id'] != job.id).toList();
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
    _prefs ??= await SharedPreferences.getInstance();

    final user = AuthService.getCurrentUser();

    final userKey = '${key}_${user.id}';
    final jobsJson = _prefs!.getString(userKey) ?? '[]';
    final List<dynamic> jobs = json.decode(jobsJson);

    return jobs.map((jobJson) {
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
        'applicationMethod': jobJson['applicationMethod'] ??
            {
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

  static Future<List<Job>> getAvailableJobs() async {
    final savedJobs = await getSavedJobs();
    final appliedJobs = await getAppliedJobs();
    final rejectedJobs = await getRejectedJobs();

    final Set<String> interactedJobIds = {
      ...savedJobs.map((job) => job.id),
      ...appliedJobs.map((job) => job.id),
      ...rejectedJobs.map((job) => job.id),
    };

    return dummyJobs
        .where((job) => !interactedJobIds.contains(job.id))
        .toList();
  }

  static Future<void> clearAllJobData() async {
    _prefs ??= await SharedPreferences.getInstance();
    final user = AuthService.getCurrentUser();

    await _prefs!.remove('${_savedJobsKey}_${user.id}');
    await _prefs!.remove('${_appliedJobsKey}_${user.id}');
    await _prefs!.remove('${_rejectedJobsKey}_${user.id}');
  }
}

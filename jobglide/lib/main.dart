import 'package:jobglide/data/dummy_data.dart';
import 'package:jobglide/models/model.dart';

void main() {
  // Function to filter jobs based on user preferences
  List<Job> getMatchingJobs(UserPreferences prefs) {
    return dummyJobs.where((job) {
      // Match profession
      if (job.profession != prefs.profession) return false;

      // Match experience level
      if (job.experienceLevel != prefs.experienceLevel) return false;

      // Match job type
      if (!prefs.preferredJobTypes.contains(job.jobType)) return false;

      // Match remote preference
      if (prefs.remoteOnly && !job.isRemote) return false;

      // Match location if not remote
      if (!job.isRemote && job.location != prefs.location) return false;

      return true;
    }).toList();
  }

  // Simulate swiping right on matching jobs
  void applyToJobs(List<Job> matchingJobs, User user) {
    for (final job in matchingJobs) {
      if (!user.appliedJobs.contains(job.id)) {
        user.appliedJobs.add(job.id);
      }
    }
  }

  // Get matching jobs
  final matchingJobs = getMatchingJobs(userPreferences);

  // Simulate user swiping right on matching jobs
  applyToJobs(matchingJobs, dummyUsers[0]);

  // Print results
  print('\n=== User Preferences ===');
  print('Location: ${userPreferences.location}');
  print('Experience: ${userPreferences.experienceLevel.toDisplayString()}');
  print('Profession: ${userPreferences.profession.toDisplayString()}');
  print(
      'Preferred Job Types: ${userPreferences.preferredJobTypes.map((type) => type.toDisplayString()).join(", ")}');
  print('Remote Only: ${userPreferences.remoteOnly}');
  print('Expected Salary: ${userPreferences.expectedSalary}');

  print('\n=== Matching Jobs ===');
  if (matchingJobs.isEmpty) {
    print('No matching jobs found.');
  } else {
    for (final job in matchingJobs) {
      print('\n${job.title} at ${job.company}');
      print('Location: ${job.location}');
      print('Type: ${job.jobType.toDisplayString()}');
      print('Salary: ${job.salary}');
      print('Remote: ${job.isRemote}');
      print('Requirements:');
      for (final req in job.requirements) {
        print('- $req');
      }
    }
  }

  // Print applied jobs (jobs user swiped right on)
  print('\n=== Applied Jobs (Swiped Right) ===');
  final appliedJobs = dummyJobs
      .where((job) => dummyUsers[0].appliedJobs.contains(job.id))
      .toList();

  if (appliedJobs.isEmpty) {
    print('No jobs applied to yet.');
  } else {
    for (final job in appliedJobs) {
      print('\n${job.title} at ${job.company}');
      print('Location: ${job.location}');
      print('Type: ${job.jobType.toDisplayString()}');
      print('Salary: ${job.salary}');
    }
  }

  print('\n=== All Available Jobs ===');
  for (final job in dummyJobs) {
    print('\n${job.title} at ${job.company}');
    print('Location: ${job.location}');
    print('Profession: ${job.profession.toDisplayString()}');
    print('Experience: ${job.experienceLevel.toDisplayString()}');
  }
}

import '../enums/job_type.dart';
import 'job.dart';

class JobFilter {
  final List<String>? professions;
  final List<JobType>? jobTypes;
  final bool? remoteOnly;
  final String? location;
  final String? minSalary;
  final String? maxSalary;

  const JobFilter({
    this.professions,
    this.jobTypes,
    this.remoteOnly,
    this.location,
    this.minSalary,
    this.maxSalary,
  });

  JobFilter copyWith({
    List<String>? professions,
    List<JobType>? jobTypes,
    bool? remoteOnly,
    String? location,
    String? minSalary,
    String? maxSalary,
  }) {
    return JobFilter(
      professions: professions ?? this.professions,
      jobTypes: jobTypes ?? this.jobTypes,
      remoteOnly: remoteOnly ?? this.remoteOnly,
      location: location ?? this.location,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
    );
  }

  bool matches(Job job) {
    // Job type check
    if (jobTypes?.isNotEmpty ?? false) {
      if (!jobTypes!.contains(job.jobType)) {
        return false;
      }
    }

    // Remote work check
    if (remoteOnly ?? false) {
      if (!job.isRemote) {
        return false;
      }
    }

    // Location check
    if (location?.isNotEmpty ?? false) {
      if (!job.location.toLowerCase().contains(location!.toLowerCase())) {
        return false;
      }
    }

    // Profession check
    if (professions?.isNotEmpty ?? false) {
      bool matchesAnyProfession = professions!.any((p) {
        final pLower = p.toLowerCase();
        return job.profession.toLowerCase() == pLower ||
            job.title.toLowerCase().contains(pLower) ||
            job.description.toLowerCase().contains(pLower);
      });
      if (!matchesAnyProfession) {
        return false;
      }
    }

    return true;
  }
}

// Enums for better type safety
enum JobType {
  fullTime,
  partTime,
  contract,
  internship;

  String toDisplayString() {
    switch (this) {
      case JobType.fullTime:
        return 'Full Time';
      case JobType.partTime:
        return 'Part Time';
      case JobType.contract:
        return 'Contract';
      case JobType.internship:
        return 'Internship';
    }
  }
}

enum JobStatus {
  saved,
  applied,
  rejected;

  String toDisplayString() {
    switch (this) {
      case JobStatus.saved:
        return 'Saved';
      case JobStatus.applied:
        return 'Applied';
      case JobStatus.rejected:
        return 'Rejected';
    }
  }
}

class UserPreferences {
  final List<String> professions;
  final bool remoteOnly;
  final List<JobType> preferredJobTypes;

  const UserPreferences({
    required this.professions,
    required this.remoteOnly,
    required this.preferredJobTypes,
  });

  Map<String, dynamic> toJson() {
    return {
      'professions': professions,
      'remoteOnly': remoteOnly,
      'preferredJobTypes': preferredJobTypes.map((t) => t.toString()).toList(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      professions: List<String>.from(json['professions'] ?? []),
      remoteOnly: json['remoteOnly'] ?? false,
      preferredJobTypes: (json['preferredJobTypes'] as List?)
              ?.map((t) => JobType.values.firstWhere(
                    (e) => e.toString() == t,
                    orElse: () => JobType.fullTime,
                  ))
              .toList() ??
          [],
    );
  }

  UserPreferences copyWith({
    List<String>? professions,
    bool? remoteOnly,
    List<JobType>? preferredJobTypes,
  }) {
    return UserPreferences(
      professions: professions ?? this.professions,
      remoteOnly: remoteOnly ?? this.remoteOnly,
      preferredJobTypes: preferredJobTypes ?? this.preferredJobTypes,
    );
  }
}

class User {
  final String id;
  final String email;
  final String name;
  final bool autoApplyEnabled;
  final UserPreferences preferences;
  final Map<String, JobStatus> jobStatuses;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.autoApplyEnabled,
    required this.preferences,
    required this.jobStatuses,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'autoApplyEnabled': autoApplyEnabled,
      'preferences': preferences.toJson(),
      'jobStatuses': jobStatuses.map(
        (key, value) => MapEntry(key, value.toString().split('.').last),
      ),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      autoApplyEnabled: json['autoApplyEnabled'] as bool,
      preferences: UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      jobStatuses: (json['jobStatuses'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          JobStatus.values.firstWhere(
            (status) => status.toString().split('.').last == value,
          ),
        ),
      ),
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    bool? autoApplyEnabled,
    UserPreferences? preferences,
    Map<String, JobStatus>? jobStatuses,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      autoApplyEnabled: autoApplyEnabled ?? this.autoApplyEnabled,
      preferences: preferences ?? this.preferences,
      jobStatuses: jobStatuses ?? this.jobStatuses,
    );
  }
}

class ApplicationMethod {
  final String type;
  final String value;
  final String? instructions;

  const ApplicationMethod({
    required this.type,
    required this.value,
    this.instructions,
  });

  // Convert ApplicationMethod to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'instructions': instructions,
    };
  }

  // Create ApplicationMethod from JSON
  factory ApplicationMethod.fromJson(Map<String, dynamic> json) {
    return ApplicationMethod(
      type: json['type'] as String,
      value: json['value'] as String,
      instructions: json['instructions'] as String?,
    );
  }
}

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final List<String> requirements;
  final JobType jobType;
  final bool isRemote;
  final String profession;
  final ApplicationMethod applicationMethod;
  final DateTime postedDate;
  final String salary;
  final String? companyWebsite;
  final String? applicationStatus;
  final DateTime? appliedDate;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.requirements,
    required this.jobType,
    required this.isRemote,
    required this.profession,
    required this.applicationMethod,
    required this.postedDate,
    required this.salary,
    this.companyWebsite,
    this.applicationStatus,
    this.appliedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'requirements': requirements,
      'jobType': jobType.toString(),
      'isRemote': isRemote,
      'profession': profession,
      'applicationMethod': applicationMethod.toJson(),
      'postedDate': postedDate.toIso8601String(),
      'salary': salary,
      'companyWebsite': companyWebsite,
      'applicationStatus': applicationStatus,
      'appliedDate': appliedDate?.toIso8601String(),
    };
  }

  factory Job.fromJson(Map<String, dynamic> json) {
    // Helper function to safely cast to List<String>
    List<String> safeStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e?.toString() ?? '').toList();
      }
      return [];
    }

    return Job(
      id: json['id']?.toString() ?? 'unknown',
      title: json['title']?.toString() ?? 'Unknown Job',
      company: json['company']?.toString() ?? 'Unknown Company',
      location: json['location']?.toString() ?? 'Remote',
      description: json['description']?.toString() ?? 'No description available',
      requirements: safeStringList(json['requirements']),
      jobType: JobType.values.firstWhere(
        (e) => e.toString() == json['jobType'],
        orElse: () => JobType.fullTime,
      ),
      isRemote: json['isRemote'] as bool? ?? false,
      profession: json['profession']?.toString() ?? 'Unknown',
      applicationMethod: json['applicationMethod'] is Map 
          ? ApplicationMethod.fromJson(json['applicationMethod'] as Map<String, dynamic>)
          : ApplicationMethod(type: 'email', value: 'unknown@example.com'),
      postedDate: json['postedDate'] != null 
          ? DateTime.parse(json['postedDate'] as String)
          : DateTime.now(),
      salary: json['salary']?.toString() ?? 'Competitive',
      companyWebsite: json['companyWebsite']?.toString(),
      applicationStatus: json['status']?.toString(),
      appliedDate: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }
}

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

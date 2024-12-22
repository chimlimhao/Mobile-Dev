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
  final String profession;
  final bool remoteOnly;
  final List<JobType> preferredJobTypes;

  const UserPreferences({
    required this.profession,
    required this.remoteOnly,
    required this.preferredJobTypes,
  });

  Map<String, dynamic> toJson() {
    return {
      'profession': profession,
      'remoteOnly': remoteOnly,
      'preferredJobTypes': preferredJobTypes.map((e) => e.toString().split('.').last).toList(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      profession: json['profession'] as String,
      remoteOnly: json['remoteOnly'] as bool,
      preferredJobTypes: (json['preferredJobTypes'] as List)
          .map((e) => JobType.values.firstWhere(
                (type) => type.toString().split('.').last == e,
              ))
          .toList(),
    );
  }

  UserPreferences copyWith({
    String? profession,
    bool? remoteOnly,
    List<JobType>? preferredJobTypes,
  }) {
    return UserPreferences(
      profession: profession ?? this.profession,
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
  final String? applicationStatus;  // Added for tracking application status
  final DateTime? appliedDate;      // Added for tracking when user applied

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

  // Convert Job to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'requirements': requirements.toList(),
      'jobType': jobType.toString().split('.').last,
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

  // Create Job from JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      requirements: (json['requirements'] as List).map((e) => e.toString()).toList(),
      jobType: JobType.values.firstWhere(
        (type) => type.toString().split('.').last == json['jobType'],
      ),
      isRemote: json['isRemote'] as bool,
      profession: json['profession'] as String,
      applicationMethod: ApplicationMethod.fromJson(json['applicationMethod'] as Map<String, dynamic>),
      postedDate: DateTime.parse(json['postedDate'] as String),
      salary: json['salary'] as String,
      companyWebsite: json['companyWebsite'] as String?,
      applicationStatus: json['applicationStatus'] as String?,
      appliedDate: json['appliedDate'] != null ? DateTime.parse(json['appliedDate'] as String) : null,
    );
  }
}

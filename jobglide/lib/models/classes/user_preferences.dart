import '../enums/job_type.dart';

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

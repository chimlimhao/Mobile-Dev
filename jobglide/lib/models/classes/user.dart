import '../enums/job_status.dart';
import 'user_preferences.dart';

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
      preferences:
          UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
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

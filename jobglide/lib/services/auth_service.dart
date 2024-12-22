import 'package:jobglide/models/model.dart';

class AuthService {
  static User _mockUser = User(
    id: 'mock_user_1',
    email: 'user@example.com',
    name: 'John Doe',
    autoApplyEnabled: false,
    preferences: const UserPreferences(
      profession: 'Software Developer',
      remoteOnly: true,
      preferredJobTypes: [JobType.fullTime, JobType.contract],
    ),
    jobStatuses: {},
  );

  static User getCurrentUser() {
    return _mockUser;
  }

  static bool isAutoApplyEnabled() {
    return _mockUser.autoApplyEnabled;
  }

  static void setAutoApplyEnabled(bool enabled) {
    _mockUser = _mockUser.copyWith(autoApplyEnabled: enabled);
  }

  static void updateUserPreferences(UserPreferences preferences) {
    _mockUser = _mockUser.copyWith(preferences: preferences);
  }

  static void updateJobStatus(String jobId, JobStatus status) {
    final updatedStatuses = Map<String, JobStatus>.from(_mockUser.jobStatuses);
    updatedStatuses[jobId] = status;
    _mockUser = _mockUser.copyWith(jobStatuses: updatedStatuses);
  }
}

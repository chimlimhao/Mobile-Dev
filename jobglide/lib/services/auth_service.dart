import 'package:jobglide/models/model.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static User? _currentUser;
  static UserPreferences? _userPreferences;

  static const Uuid uuid = Uuid();

  // Pre-created user account
  static final User _defaultUser = User(
    id: uuid.v4(),
    name: 'John Doe',
    email: 'john@example.com',
    appliedJobs: [],
  );

  // Pre-created user preferences
  static final UserPreferences _defaultPreferences = UserPreferences(
    location: 'San Francisco',
    experienceLevel: ExperienceLevel.intermediate,
    profession: Profession.mobileDev,
    preferredJobTypes: [JobType.fullTime],
    expectedSalary: '\$80,000 - \$120,000',
    remoteOnly: true,
  );

  // Simple login with pre-created account
  static bool login(String email, String password) {
    if (email == 'john@example.com' && password == '123456') {
      _currentUser = _defaultUser;
      _userPreferences = _defaultPreferences;
      return true;
    }
    return false;
  }

  // Get current user
  static User? getCurrentUser() {
    return _currentUser;
  }

  // Get user preferences
  static UserPreferences? getUserPreferences() {
    return _userPreferences;
  }

  // Update user preferences
  static void updateUserPreferences(UserPreferences newPrefs) {
    _userPreferences = newPrefs;
  }

  // Logout user
  static void logout() {
    _currentUser = null;
    _userPreferences = null;
  }

  // Add applied job
  static void addAppliedJob(String jobId) {
    _currentUser?.appliedJobs.add(jobId);
  }

  // Check if job is already applied
  static bool hasAppliedToJob(String jobId) {
    return _currentUser?.appliedJobs.contains(jobId) ?? false;
  }
}

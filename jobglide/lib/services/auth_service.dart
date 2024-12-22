import 'package:jobglide/models/model.dart';
import 'package:jobglide/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static User? _currentUser;
  static final _storage = StorageService();
  static final  _uuid = Uuid();

  // Initialize the auth service
  static Future<void> init() async {
    final userId = await _storage.getString('userId');
    if (userId != null) {
      final user = await _storage.getUser(userId);
      if (user != null) {
        _currentUser = user;
      }
    }
  }

  // Get current user
  static User? getCurrentUser() {
    return _currentUser;
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return _currentUser != null;
  }

  // Check if auto-apply is enabled
  static bool isAutoApplyEnabled() {
    return _currentUser?.autoApplyEnabled ?? false;
  }

  // Set auto-apply preference
  static Future<void> setAutoApplyEnabled(bool enabled) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(autoApplyEnabled: enabled);
      await _storage.saveUser(_currentUser!);
    }
  }

  // Update job status
  static Future<void> updateJobStatus(String jobId, JobStatus status) async {
    if (_currentUser != null) {
      final updatedStatuses = Map<String, JobStatus>.from(_currentUser!.jobStatuses);
      updatedStatuses[jobId] = status;
      _currentUser = _currentUser!.copyWith(jobStatuses: updatedStatuses);
      await _storage.saveUser(_currentUser!);
    }
  }

  // Login user (simulated)
  static Future<User> login(String email, String password) async {
    // In a real app, validate credentials here
    final userId = await _storage.getString('userId') ?? _uuid.v4();
    await _storage.setString('userId', userId);

    _currentUser = User(
      id: userId,
      email: email,
      name: 'Test User',
      autoApplyEnabled: false,
      preferences: UserPreferences(
        profession: 'Software Developer',
        remoteOnly: false,
        preferredJobTypes: [JobType.fullTime],
      ),
      jobStatuses: {},
    );

    await _storage.saveUser(_currentUser!);
    return _currentUser!;
  }

  // Logout user
  static Future<void> logout() async {
    _currentUser = null;
    await _storage.clear();
  }

  // Update user preferences
  static Future<void> updateUserPreferences(UserPreferences preferences) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(preferences: preferences);
      await _storage.saveUser(_currentUser!);
    }
  }
}

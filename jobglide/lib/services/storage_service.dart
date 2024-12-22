import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobglide/models/model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late SharedPreferences _prefs;
  static const String _isFirstTimeKey = 'is_first_time';

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // First time check
  bool isFirstTime() {
    return _prefs.getBool(_isFirstTimeKey) ?? true;
  }

  Future<void> setFirstTime(bool value) async {
    await _prefs.setBool(_isFirstTimeKey, value);
  }

  // String operations
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  // User operations
  Future<User?> getUser(String userId) async {
    final userJson = _prefs.getString('user_$userId');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<bool> saveUser(User user) async {
    return _prefs.setString('user_${user.id}', jsonEncode(user.toJson()));
  }

  Future<bool> clear() async {
    return _prefs.clear();
  }
}

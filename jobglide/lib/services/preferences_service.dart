import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _showApplyConfirmationKey = 'show_apply_confirmation';

  static Future<bool> shouldShowApplyConfirmation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showApplyConfirmationKey) ?? true;
  }

  static Future<void> setShowApplyConfirmation(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showApplyConfirmationKey, show);
  }
}

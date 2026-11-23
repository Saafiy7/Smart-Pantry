import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _lastViewedKey = 'last_viewed_product';

  static Future<void> saveLastViewed(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastViewedKey, name);
  }

  static Future<String?> getLastViewed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastViewedKey);
  }
}
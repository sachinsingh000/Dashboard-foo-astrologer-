import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  // MUST call in main()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // CLEAR EVERYTHING
  static Future<void> clear() async {
    await _prefs.clear();
  }

  // TOKEN
  static Future<void> saveToken(String token) async {
    await _prefs.setString("token", token);
  }

  static String? getToken() {
    return _prefs.getString("token");
  }

  // ASTROLOGER ID
  static Future<void> saveAstrologerId(String id) async {
    await _prefs.setString("astrologerId", id);
  }

  static String? getAstrologerId() {
    return _prefs.getString("astrologerId");
  }


  static Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
  }

  static Future<void> setUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
  }
  // FULL ASTROLOGER JSON
  static Future<void> saveAstrologer(String astroJson) async {
    await _prefs.setString("astrologer", astroJson);
  }

  static String? getAstrologer() {
    return _prefs.getString("astrologer");
  }
}

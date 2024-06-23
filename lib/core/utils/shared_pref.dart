import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setData(
      {required String key, required dynamic value}) async {
    if (value is String) {
      await prefs.setString(key, value);
      return true;
    }

    if (value is bool) {
      await prefs.setBool(key, value);
      return true;
    }

    if (value is int) {
      await prefs.setInt(key, value);
      return true;
    }
    if (value is double) {
      await prefs.setDouble(key, value);
      return true;
    }

    return false;
  }

  static Future<bool> removeData({required String key}) async {
    await prefs.remove(key);
    return true;
  }

  static dynamic getData({required String key})  {
    return prefs.get(key);
  }

  static Future<bool> clearAllPrefs() async {
    await prefs.clear();
    return true;
  }

}

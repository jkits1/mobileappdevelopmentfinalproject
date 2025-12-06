import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {

  static final PreferencesManager instance = PreferencesManager._internal();
  PreferencesManager._internal();

  static const String userNameKey = 'userName';
  static const String darkModeKey = 'darkMode';

  Future<void> setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, userName);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    // user_name to userNameKey
    return prefs.getString(userNameKey);
  }

  Future<void> setDarkMode(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkModeKey, darkMode);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(darkModeKey) ?? false;
  }

  Future<bool> isFirstRun() async {
    final userName = await getUserName();
    return userName == null || userName.isEmpty;
  }
}
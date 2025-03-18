import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  // Private constructor to prevent instantiation
  UserSession._();

  // SharedPreferences keys
  static const String _keyUserId = 'user_id';
  static const String _keyName = 'user_name';
  static const String _keyPhone = 'user_phone';
  static const String _keyEmail = 'user_email';
  static const String _keyReffer = 'user_reffer';
  static const String _keyProfileImage = 'user_profile_image';
  static const String _keyPin = 'user_pin';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Save user session data
  static Future<void> saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyUserId, userData['id']?.toString() ?? '');
    await prefs.setString(_keyName, userData['name']?.toString() ?? '');
    await prefs.setString(_keyPhone, userData['phone']?.toString() ?? '');
    await prefs.setString(_keyEmail, userData['email']?.toString() ?? '');
    await prefs.setString(_keyReffer, userData['reffer']?.toString() ?? '');
    await prefs.setString(
        _keyProfileImage, userData['profile_image']?.toString() ?? '');
    await prefs.setString(_keyPin, userData['pin']?.toString() ?? '');
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // Individual getters for each field
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId) ?? '';
  }

  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName) ?? '';
  }

  static Future<String> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhone) ?? '';
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? '';
  }

  static Future<String> getReffer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyReffer) ?? '';
  }

  static Future<String> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileImage) ?? '';
  }

  static Future<String> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPin) ?? '';
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Clear session
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Get all user data at once
  static Future<Map<String, String>> getAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(_keyUserId) ?? '',
      'name': prefs.getString(_keyName) ?? '',
      'phone': prefs.getString(_keyPhone) ?? '',
      'email': prefs.getString(_keyEmail) ?? '',
      'reffer': prefs.getString(_keyReffer) ?? '',
      'profile_image': prefs.getString(_keyProfileImage) ?? '',
      'pin': prefs.getString(_keyPin) ?? '',
    };
  }
}

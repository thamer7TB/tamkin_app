
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // 🔐 حفظ بيانات تسجيل الدخول
  static Future<void> saveLoginData({
    required String userType,
    required String email,
    required String token,
    required String userId,
    String? lastName,
    String? profileImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
    await prefs.setString('email', email);
    await prefs.setString('token', token);
    await prefs.setString('userId', userId);
    if (lastName != null) await prefs.setString('lastName', lastName);
    if (profileImage != null) await prefs.setString('profileImage', profileImage);
  }

  // 📥 استرجاع بيانات المستخدم
  static Future<Map<String, String>?> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final token = prefs.getString('token');
    final userType = prefs.getString('userType');
    final userId = prefs.getString('userId');
    final lastName = prefs.getString('lastName');
    final profileImage = prefs.getString('profileImage');

    if (email != null && token != null && userType != null && userId != null) {
      return {
        'email': email,
        'token': token,
        'userType': userType,
        'userId': userId,
        'lastName': lastName ?? '',
        'profileImage': profileImage ?? '',
      };
    }
    return null;
  }

  // ❌ حذف بيانات المستخدم
  static Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('token');
    await prefs.remove('userType');
    await prefs.remove('userId');
    await prefs.remove('lastName');
    await prefs.remove('profileImage');
  }

  // 🟢 حفظ حالة مشاهدة Onboarding
  static Future<void> setSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

  // 🔄 التحقق هل شاهد المستخدم Onboarding؟
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seenOnboarding') ?? false;
  }
  // Update Profile Image

  static Future<void> updateProfileImage(String newUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('loginData');

    if (data != null) {
      final Map<String, dynamic> jsonData = jsonDecode(data);
      jsonData['profileImage'] = newUrl;
      await prefs.setString('loginData', jsonEncode(jsonData));
    }
  }

}


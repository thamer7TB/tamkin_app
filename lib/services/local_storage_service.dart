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

    print('Saved login data: userType=$userType, email=$email, token=$token, userId=$userId, lastName=$lastName, profileImage=$profileImage');
  }

  // 📥 استرجاع بيانات المستخدم
  static Future<Map<String, dynamic>?> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final token = prefs.getString('token');
    final userType = prefs.getString('userType');
    final userId = prefs.getString('userId');
    final lastName = prefs.getString('lastName');
    final profileImage = prefs.getString('profileImage');
    final centerName = prefs.getString('centerName');
    final institutionType = prefs.getString('institutionType');
    final specializations = prefs.getString('specializations');
    final wilaya = prefs.getString('wilaya');
    final commune = prefs.getString('commune');
    final street = prefs.getString('street');
    final website = prefs.getString('website');
    final facebook = prefs.getString('facebook');
    final linkedin = prefs.getString('linkedin');
    final twitter = prefs.getString('twitter');
    final secondPhone = prefs.getString('secondPhone');
    final logoUrl = prefs.getString('logoUrl');

    if (email != null && token != null && userType != null && userId != null) {
      return {
        'email': email,
        'token': token,
        'userType': userType,
        'userId': userId,
        'lastName': lastName ?? '',
        'profileImage': profileImage ?? '',
        'centerName': centerName ?? '',
        'institutionType': institutionType ?? '',
        'specializations': specializations != null ? jsonDecode(specializations) : [],
        'wilaya': wilaya ?? '',
        'commune': commune ?? '',
        'street': street ?? '',
        'website': website ?? '',
        'facebook': facebook ?? '',
        'linkedin': linkedin ?? '',
        'twitter': twitter ?? '',
        'secondPhone': secondPhone ?? '',
        'logoUrl': logoUrl ?? '',
      };
    }
    return null;
  }

  // 🔄 تحديث بيانات تسجيل الدخول
  static Future<void> updateLoginData(Map<String, dynamic> updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    final currentData = await getLoginData() ?? {};

    // دمج البيانات الحالية مع البيانات المحدثة
    final mergedData = {...currentData, ...updatedData};

    // تحويل القوائم إلى سلاسل JSON إذا لزم الأمر
    if (mergedData['specializations'] != null && mergedData['specializations'] is List) {
      mergedData['specializations'] = jsonEncode(mergedData['specializations']);
    }

    // حفظ البيانات المحدثة
    for (var entry in mergedData.entries) {
      if (entry.value != null) {
        await prefs.setString(entry.key, entry.value.toString());
      }
    }

    print('Updated login data: $mergedData');
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
    await prefs.remove('centerName');
    await prefs.remove('institutionType');
    await prefs.remove('specializations');
    await prefs.remove('wilaya');
    await prefs.remove('commune');
    await prefs.remove('street');
    await prefs.remove('website');
    await prefs.remove('facebook');
    await prefs.remove('linkedin');
    await prefs.remove('twitter');
    await prefs.remove('secondPhone');
    await prefs.remove('logoUrl');
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

  // 🔄 تحديث صورة الملف الشخصي
  static Future<void> updateProfileImage(String newUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', newUrl);
    await prefs.setString('logoUrl', newUrl); // دعم لشعار المركز
  }
}
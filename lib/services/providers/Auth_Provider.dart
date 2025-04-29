
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../local_storage_service.dart';
class AuthProvider with ChangeNotifier {
  // حالة لإظهار أو إخفاء كلمة المرور
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // حالة تحميل أثناء تسجيل الدخول
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // رسالة الخطأ
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // تسجيل الدخول (بشكل وهمي الآن، لاحقًا نربطها بـ API) مع التعدبل عليها
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // محاكاة الاتصال بالخادم

    // تحقق وهمي
    if (email == "test@example.com" && password == "123456") {
      // 🧠 بعد نجاح التحقق الوهمي نحفظ البيانات
      await LocalStorageService.saveLoginData(
        userType: "trainee", // في التطبيق الحقيقي ستأتي من الـ API
        email: email,
        token: "sample_token", // من الـ API
        lastName: "BenAli",    // أيضاً من الـ API
        userId: "u1234",        // من الـ API
        profileImage: null,     // حالياً null
      );

      _isLoading = false;
      notifyListeners();
    } else {
      // فشل
      _isLoading = false;
      _errorMessage = "Email or password is incorrect";
      notifyListeners();
    }
  }


  // إعادة تعيين الخطأ عند الحاجة
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ✅ تسجيل حساب جديد (وهمية حاليًا)
  // ✅ دالة تسجيل مستخدم باحث عن تدريب/تكوين
  Future<void> signupTrainee({
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _setError("Please fill in all fields.");
      _setLoading(false);
      return;
    }

    if (!email.contains("@")) {
      _setError("Please enter a valid email.");
      _setLoading(false);
      return;
    }

    if (password != confirmPassword) {
      _setError("Passwords do not match.");
      _setLoading(false);
      return;
    }

    _setLoading(false);
    // Send to API later
  }

// ✅ دالة تسجيل شركة
  Future<void> signupCompany({
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String registrationNumber, // رقم السجل التجاري
  }) async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty || registrationNumber.isEmpty) {
      _setError("Please fill in all fields.");
      _setLoading(false);
      return;
    }

    if (!email.contains("@")) {
      _setError("Please enter a valid email.");
      _setLoading(false);
      return;
    }

    if (password != confirmPassword) {
      _setError("Passwords do not match.");
      _setLoading(false);
      return;
    }

    // ✅ تحقق إضافي للسجل التجاري إن أردت
    if (registrationNumber.length < 5) {
      _setError("Invalid registration number.");
      _setLoading(false);
      return;
    }

    _setLoading(false);
    // Send to API later
  }

  // ✅ دالة تسجيل مركز تكوين
  Future<void> signupCenter({
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String accreditationNumber, // رقم الاعتماد
  }) async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty || accreditationNumber.isEmpty) {
      _setError("Please fill in all fields.");
      _setLoading(false);
      return;
    }

    if (!email.contains("@")) {
      _setError("Please enter a valid email.");
      _setLoading(false);
      return;
    }

    if (password != confirmPassword) {
      _setError("Passwords do not match.");
      _setLoading(false);
      return;
    }

    // ✅ تحقق من رقم الاعتماد إن أردت
    if (accreditationNumber.length < 5) {
      _setError("Invalid accreditation number.");
      _setLoading(false);
      return;
    }

    _setLoading(false);
    // Send to API later
  }

  Future<void> signupTrainer({
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(seconds: 2)); // مؤقت وهمي

    if (email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _setError("Please fill in all fields.");
      _setLoading(false);
      return;
    }

    if (!email.contains("@")) {
      _setError("Please enter a valid email.");
      _setLoading(false);
      return;
    }

    if (password != confirmPassword) {
      _setError("Passwords do not match.");
      _setLoading(false);
      return;
    }

    try {
      // ✅ هنا سيكون الاتصال الحقيقي بـ API الخاص بالمدربين مستقبلاً
      final response = await http.post(
        Uri.parse("https://your-api.com/api/trainers/signup"), // ← عدل لاحقًا
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "phone": phone,
          "password": password,
          "confirmPassword": confirmPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // success
      } else {
        _setError("Failed to register. Please try again.");
      }
    } catch (e) {
      _setError("Error occurred: ${e.toString()}");
    }

    _setLoading(false);
  }




  // مساعدة
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

}

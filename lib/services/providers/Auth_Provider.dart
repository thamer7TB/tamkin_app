
import 'package:flutter/material.dart';

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
      // نجاح
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
  Future<void> signup({
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(seconds: 2)); // مؤقت

    // تحقق وهمي
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

    // نجاح وهمي
    _setLoading(false);
    // في الواقع: قم هنا بإرسال البيانات إلى API
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

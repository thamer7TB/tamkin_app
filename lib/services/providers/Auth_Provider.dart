import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../presentaions/pages/login_sginup_form/Center_3/Center_Form_Screen.dart';
import '../local_storage_service.dart';


class AuthProvider with ChangeNotifier {
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> login(BuildContext context, String email, String password) async {
    _setLoading(true);
    clearError();
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://tamkeens.up.railway.app/loginEmail'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];
        final userId = user['id'].toString();
        final userType = user['entity_type'];
        final name = user['name'] ?? '';
        final lastName = name;
        final profileImage = user['profile_picture'] ?? '';

        print('Raw name from API: $name');

        await LocalStorageService.saveLoginData(
          userType: userType,
          email: email,
          token: token,
          lastName: lastName,
          userId: userId,
          profileImage: profileImage,
        );

        print('Data saved to LocalStorage: userType=$userType, email=$email, token=$token, lastName=$lastName, userId=$userId, profileImage=$profileImage');

        Navigator.pushReplacementNamed(context, " /redirector ");
      } else if (response.statusCode == 400) {
        print('Status: ${response.statusCode}, Body: ${response.body}');
        _setError('Invalid email or password');
      } else if (response.statusCode == 500) {
        print('Status: ${response.statusCode}, Body: ${response.body}');
        _setError('Server error, please try again later');
      } else {
        print('Status: ${response.statusCode}, Body: ${response.body}');
        _setError('Login failed, please try again');
      }
    } catch (e) {
      print('Exception: $e');
      _setError('An error occurred: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signupTrainee({
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    clearError();
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _setError("Please fill in all fields.");
      _setLoading(false);
      notifyListeners();
      return;
    }

    if (!email.contains("@")) {
      _setError("Please enter a valid email.");
      _setLoading(false);
      notifyListeners();
      return;
    }

    if (phone.isEmpty || phone.length < 6 || phone.length > 15) {
      _setError("Please enter a valid phone number (6-15 digits).");
      _setLoading(false);
      notifyListeners();
      return;
    }

    if (password.length < 6) {
      _setError("Password must be at least 6 characters long.");
      _setLoading(false);
      notifyListeners();
      return;
    }

    if (password != confirmPassword) {
      _setError("Passwords do not match.");
      _setLoading(false);
      notifyListeners();
      return;
    }

    _setLoading(false);
    notifyListeners();
  }

  Future<void> signupCompany({
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String registrationNumber,
  }) async {
    _setLoading(true);
    clearError();

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

    if (registrationNumber.length < 5) {
      _setError("Invalid registration number.");
      _setLoading(false);
      return;
    }

    _setLoading(false);
  }

  Future<void> signupCenter({
    required BuildContext context,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String accreditationNumber,
  }) async {
    _setLoading(true);
    clearError();
    notifyListeners();

    if (email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty || accreditationNumber.isEmpty) {
      _setError("Please fill in all fields.");
      _setLoading(false);
      notifyListeners();
      return;
    }

    if (!email.contains("@")) {
      _setError("Please enter a valid email.");
      _setLoading(false);
      notifyListeners();
      return;
    }

    if (phone.isEmpty || phone.length < 6 || phone.length > 15) {
      _setError("Please enter a valid phone number (6-15 digits).");
      _setLoading(false);
      notifyListeners();
      return;
    }

    if (password.length < 6) {
      _setError("Password must be at least 6 characters long.");
      _setLoading(false);
      notifyListeners();
      return;
    }

    if (password != confirmPassword) {
      _setError("Passwords do not match.");
      _setLoading(false);
      notifyListeners();
      return;
    }

    if (accreditationNumber.length < 5) {
      _setError("Invalid accreditation number.");
      _setLoading(false);
      notifyListeners();
      return;
    }

    _setLoading(false);
    notifyListeners();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainingCenterFormScreen(
          email: email,
          phone: phone,
          password: password,
          accreditationNumber: accreditationNumber,
        ),
      ),
    );
  }

  Future<void> signupTrainer({
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    clearError();

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

    try {
      final response = await http.post(
        Uri.parse("https://tamkeens.up.railway.app/api/trainers/signup"),
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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
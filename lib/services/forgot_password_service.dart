// File: forget_password_service.dart
import 'package:flutter/material.dart';

class ForgetPasswordService {
  // Simulated email verification
  static Future<bool> verifyEmailExists(String email) async {
    await Future.delayed(Duration(seconds: 1));
    return email == 'test@email.com';
  }

  // Simulated OTP sending
  static Future<void> sendOtp(String email) async {
    await Future.delayed(Duration(seconds: 1));
  }

  // Simulated OTP verification
  static Future<bool> verifyOtp(String otp) async {
    await Future.delayed(Duration(seconds: 1));
    return otp == '1234';
  }

  // Simulated password reset
  static Future<bool> resetPassword(String password, String confirmPassword) async {
    await Future.delayed(Duration(seconds: 1));
    return password == confirmPassword;
  }
}



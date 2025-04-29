
// models/user_model.dart
// lib/models/profile_model.dart
class ProfileModel {
// المعلومات الأساسية
  String firstName = '';
  String lastName = '';
  DateTime? dateOfBirth;
  String gender = 'Male';

  // الموقع
  String? wilaya;
  String commune = '';
  String street = '';

  // التعليم والاهتمامات
  String? educationLevel;
  List<String> interests = [];
  List<String> skills = [];

  // الملفات
  String? profilePicture;
  String? cv;
  String? diploma;

  // الإعدادات
  bool receiveNotifications = true;

  // Constructor مع قيم افتراضية
  ProfileModel({
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirth,
    this.gender = 'Male',
    this.wilaya,
    this.commune = '',
    this.street = '',
    this.educationLevel,
    List<String>? interests,
    List<String>? skills,
    this.profilePicture,
    this.cv,
    this.diploma,
    this.receiveNotifications = true,
  }) : interests = interests ?? [],
        skills = skills ?? [];

  // تحويل إلى Map لإرسال للخادم
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'wilaya': wilaya,
      'commune': commune,
      'street': street,
      'education_level': educationLevel,
      'interests': interests,
      'skills': skills,
      'profile_picture': profilePicture,
      'cv': cv,
      'diploma': diploma,
      'receive_notifications': receiveNotifications,
    };
  }
}
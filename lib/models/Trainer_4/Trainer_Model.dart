// models/trainer_model.dart
class TrainerModel {
  String firstName;
  String lastName;
  DateTime? dateOfBirth;
  String gender;
  String professionalTitle;
  String yearsOfExperience;
  List<String> expertiseAreas;
  String? linkedin;
  String? profilePicture;
  String? cv;
  String? diploma;
  bool receiveNotifications;

  TrainerModel({
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.gender = 'Male',
    required this.professionalTitle,
    required this.yearsOfExperience,
    required this.expertiseAreas,
    this.linkedin,
    this.profilePicture,
    this.cv,
    this.diploma,
    this.receiveNotifications = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'professional_title': professionalTitle,
      'years_of_experience': yearsOfExperience,
      'expertise_areas': expertiseAreas,
      'linkedin': linkedin,
      'profile_picture': profilePicture,
      'cv': cv,
      'diploma': diploma,
      'receive_notifications': receiveNotifications,
    };
  }
}
// models/training_center_model.dart
class TrainingCenterModel {
  String name;
  String institutionType;
  List<String> specializations;
  String? website;
  String wilaya;
  String commune;
  String street;
  String? logo;
  String? facebook;
  String? linkedin;
  String? twitter;
  String? secondPhone;

  TrainingCenterModel({
    required this.name,
    required this.institutionType,
    required this.specializations,
    required this.wilaya,
    required this.commune,
    required this.street,
    this.website,
    this.logo,
    this.facebook,
    this.linkedin,
    this.twitter,
    this.secondPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'center_type':  institutionType,
      'specializations': specializations,
      'website': website,
      'wilaya': wilaya,
      'commune': commune,
      'street': street,
      'logo': logo,
      'facebook': facebook,
      'linkedin': linkedin,
      'twitter': twitter,
      'second_phone': secondPhone,
    };
  }
}
class TrainingCenterModel {
  String? id; // إضافة معرف المركز
  String name;
  String email;
  String password;
  String phone;
  String numeroCommerce;
  String institutionType;
  String wilaya;
  String commune;
  String street;
  List<String> specializations;
  String? website;
  String? facebook;
  String? instagram;
  String? twitter;
  String? linkedin;
  String? logo;
  String? secondPhone;

  TrainingCenterModel({
    this.id,
    this.name = '',
    this.email = '',
    this.password = '',
    this.phone = '',
    this.numeroCommerce = '',
    this.institutionType = '',
    this.wilaya = '',
    this.commune = '',
    this.street = '',
    this.specializations = const [],
    this.website,
    this.facebook,
    this.instagram,
    this.twitter,
    this.linkedin,
    this.logo,
    this.secondPhone,
  });

  factory TrainingCenterModel.fromJson(Map<String, dynamic> json) {
    return TrainingCenterModel(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: '', // لا يتم استرجاع كلمة المرور من الـ API
      phone: json['phone']?.toString() ?? '',
      numeroCommerce: json['numero_commerce']?.toString() ?? '',
      institutionType: json['type']?.toString() ?? '',
      wilaya: json['wilaya']?.toString() ?? '',
      commune: json['Commune']?.toString() ?? '',
      street: json['address']?.toString() ?? '',
      specializations: json['speciality'] != null && json['speciality'].toString().isNotEmpty
          ? json['speciality'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
          : [],
      website: json['website']?.toString(),
      facebook: json['facebook']?.toString(),
      instagram: json['instagram']?.toString(),
      twitter: json['x']?.toString(),
      linkedin: json['linkedin']?.toString(),
      logo: json['logo']?.toString(),
      secondPhone: json['secondPhone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'numero_commerce': numeroCommerce,
      'type': institutionType,
      'wilaya': wilaya,
      'Commune': commune,
      'address': street,
      'speciality': specializations.join(','),
      'website': website,
      'facebook': facebook,
      'instagram': instagram ?? '',
      'x': twitter,
      'linkedin': linkedin,
      'logo': logo,
      'secondPhone': secondPhone,
    };
  }
}
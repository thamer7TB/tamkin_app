
class CompanyModel {
  String companyName;
  String industry;
  String companySize;
  String? website;
  String wilaya;
  String commune;
  String street;
  String? logo;

  CompanyModel({
    required this.companyName,
    required this.industry,
    required this.companySize,
    required this.wilaya,
    required this.commune,
    required this.street,
    this.website,
    this.logo,
  });

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'industry': industry,
      'company_size': companySize,
      'website': website,
      'wilaya': wilaya,
      'commune': commune,
      'street': street,
      'logo': logo,
    };
  }
}


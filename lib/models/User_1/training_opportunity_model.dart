

// lib/models/User_1/training_opportunity_model.dart

class TrainingOpportunityModel {
  final String id;
  final String title;
  final String companyName;
  final String companyId;
  final String logoUrl;
  final String wilaya;
  final String domain;
  final String startDate;
  final String duration;
  final String description;
  final String requirements;
  final bool isSaved;

  TrainingOpportunityModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.companyId,
    required this.logoUrl,
    required this.wilaya,
    required this.domain,
    required this.startDate,
    required this.duration,
    required this.description,
    required this.requirements,
    this.isSaved = false,
  });

  factory TrainingOpportunityModel.fromJson(Map<String, dynamic> json) {
    return TrainingOpportunityModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      logoUrl: json['logoUrl']?.toString() ?? '',
      wilaya: json['wilaya']?.toString() ?? '',
      domain: json['domain']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      requirements: json['requirements']?.toString() ?? '',
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'companyName': companyName,
      'companyId': companyId,
      'logoUrl': logoUrl,
      'wilaya': wilaya,
      'domain': domain,
      'startDate': startDate,
      'duration': duration,
      'description': description,
      'requirements': requirements,
      'isSaved': isSaved,
    };
  }
}

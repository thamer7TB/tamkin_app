
// ملف مودل الفرص الذي سيمرر كائن الى بطافة الفرص 
class CourseOpportunityModel {
  final String id;
  final String courseTitle;
  final String centerId;
  final String centerName;
  final String logoUrl;
  final String wilaya;
  final String startDate;
  final String domain;
  final String description;
  final bool isSaved;

  CourseOpportunityModel({
    required this.id,
    required this.courseTitle,
    required this.centerId,
    required this.centerName,
    required this.logoUrl,
    required this.wilaya,
    required this.startDate,
    required this.domain,
    required this.description,
    required this.isSaved,
  });

  factory CourseOpportunityModel.fromJson(Map<String, dynamic> json) {
    return CourseOpportunityModel(
      id: json['id'],
      courseTitle: json['courseTitle'],
      centerId: json['centerId'],
      centerName: json['centerName'],
      logoUrl: json['logoUrl'],
      wilaya: json['wilaya'],
      startDate: json['startDate'],
      domain: json['domain'],
      description: json['description'],
      isSaved: json['isSaved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseTitle': courseTitle,
      'centerId': centerId,
      'centerName': centerName,
      'logoUrl': logoUrl,
      'wilaya': wilaya,
      'startDate': startDate,
      'domain': domain,
      'description': description,
      'isSaved': isSaved,
    };
  }
}

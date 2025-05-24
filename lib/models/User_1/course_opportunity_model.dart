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

  // ✅ الحقول الإضافية المطلوبة من API
  final String? duration;
  final String? schedule;
  final String? mode;
  final String? type;       // جديد
  final String? location;   // جديد
  final String? endDate;    // جديد
  final String? price;
  final String? contactEmail;
  final String? contactPhone;
  final List<String>? requirements;
  final List<String>? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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

    this.duration,
    this.schedule,
    this.mode,
    this.type,
    this.location,
    this.endDate,
    this.price,
    this.contactEmail,
    this.contactPhone,
    this.requirements,
    this.tags,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseOpportunityModel.fromJson(Map<String, dynamic> json) {
    return CourseOpportunityModel(
      id: json['id']?.toString() ?? '',
      courseTitle: json['courseTitle'] ?? '',
      centerId: json['centerId']?.toString() ?? '',
      centerName: json['centerName'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      wilaya: json['wilaya'] ?? '',
      startDate: json['startDate'] ?? '',
      domain: json['domain'] ?? '',
      description: json['description'] ?? '',
      isSaved: json['isSaved'] ?? false,

      duration: json['duration'],
      schedule: json['schedule'],
      mode: json['mode'],
      type: json['type'],
      location: json['location'],
      endDate: json['endDate'],
      price: json['price'],
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      requirements: (json['requirements'] as List?)?.map((e) => e.toString()).toList(),
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
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

      'duration': duration,
      'schedule': schedule,
      'mode': mode,
      'type': type,
      'location': location,
      'endDate': endDate,
      'price': price,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'requirements': requirements,
      'tags': tags,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}



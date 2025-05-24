class CreateOpportunityRequest {
  final String title;
  final String description;
  final String categoryId;
  final String type;
  final String mode;
  final String duration;
  final String location;
  final String startDate;
  final String endDate;

  CreateOpportunityRequest({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.type,
    required this.mode,
    required this.duration,
    required this.location,
    required this.startDate,
    required this.endDate,
  });
  Map<String, String> toMap() {
    return {
      'title': title ?? '',
      'description': description ?? '',
      'category_id': categoryId ?? '',
      'type': type ?? 'دورة',
      'mode': mode ?? 'حضوري',
      'duration': duration ?? '3 أشهر',
      'location': location ?? 'الجزائر العاصمة',
      'start_date': startDate ?? '',
      'end_date': endDate ?? '',
    };
  }
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'categoryId': categoryId,
    'type': type,
    'mode': mode,
    'duration': duration,
    'location': location,
    'startDate': startDate,
    'endDate': endDate,
  };
}


// ... ملف الخدمة الذي سيجلب معلومات الفرصة التكوينية ويملئها في المودل CourseOpportunityModel

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../mock/mock_data.dart';
import '../../models/User_1/course_opportunity_model.dart';

class CourseOpportunityService {
  static const String _baseUrl = 'https://your-api.com/api';

  /// جلب جميع فرص التكوين
 // ألدالة الاصلية للتعامل مع APi
  ///
  // Future<List<CourseOpportunityModel>> fetchCourseOpportunities() async {
  //   try {
  //     final response = await http.get(Uri.parse('$_baseUrl/courses'));
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       return data.map((json) => CourseOpportunityModel.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load course opportunities');
  //     }
  //   } catch (e) {
  //     throw Exception('Error: $e');
  //   }
  // }
  // دالة تجريبية
  Future<List<CourseOpportunityModel>> fetchCourseOpportunities() async {
    await Future.delayed(const Duration(seconds: 1)); // محاكاة التأخير

    // بيانات وهمية
    return mockCourses;
  }



  /// جلب تفاصيل فرصة واحدة (في حال احتجناها لاحقًا)
  Future<CourseOpportunityModel?> fetchCourseById(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/courses/$id'));

      if (response.statusCode == 200) {
        return CourseOpportunityModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch course details: $e');
    }
  }

}

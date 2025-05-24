import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tamkin/models/Center_3/Training_Center_Model.dart';
import 'package:tamkin/models/User_1/course_opportunity_model.dart';
import 'package:tamkin/services/local_storage_service.dart';

import '../../models/Center_3/Create_Opportunity_Request.dart';

class TrainingCenterServices {
  static const String _baseUrl = 'https://tamkeens.up.railway.app';

  // استرجاع بيانات مركز تكوين (GET /training_centers/:id)
  Future<TrainingCenterModel?> fetchTrainingCenter(String centerId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/training_centers/$centerId'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      print('Fetch Training Center Response - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TrainingCenterModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('مركز التكوين غير موجود');
      } else if (response.statusCode == 500) {
        throw Exception('خطأ في الخادم');
      } else {
        throw Exception('Failed to load training center: ${response.body}');
      }
    } catch (e) {
      print('Error fetching training center: $e');
      rethrow;
    }
  }

  // تحديث بيانات مركز تكوين (PUT /training_centers/:id)
  Future<bool> updateTrainingCenter(String centerId, String token, TrainingCenterModel center) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$_baseUrl/training_centers/$centerId'));
      request.headers.addAll({
        'Authorization': token,
      });

      final Map<String, String> centerData = center.toJson().map((key, value) => MapEntry(key, value.toString()));
      request.fields.addAll(centerData);

      if (center.logo != null && center.logo!.isNotEmpty && !center.logo!.startsWith('http')) {
        request.files.add(await http.MultipartFile.fromPath('logo', center.logo!));
        print('📤 Added updated logo: ${center.logo}');
      }

      print('Sending PUT request with fields: ${request.fields}, files: ${request.files.length}');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Update Training Center Response - Status: ${response.statusCode}, Body: $responseBody');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception('البريد الإلكتروني مستخدم بالفعل');
      } else if (response.statusCode == 404) {
        throw Exception('مركز التكوين غير موجود');
      } else if (response.statusCode == 500) {
        throw Exception('خطأ في الخادم');
      } else {
        throw Exception('Failed to update training center: $responseBody');
      }
    } catch (e) {
      print('Error updating training center: $e');
      rethrow;
    }
  }

  // حذف مركز تكوين (DELETE /training_centers/:id)
  Future<bool> deleteTrainingCenter(String centerId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/training_centers/$centerId'),
        headers: {
          'Authorization': token,
        },
      );

      print('Delete Training Center Response - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('مركز التكوين غير موجود');
      } else if (response.statusCode == 500) {
        throw Exception('خطأ في الخادم');
      } else {
        throw Exception('Failed to delete training center: ${response.body}');
      }
    } catch (e) {
      print('Error deleting training center: $e');
      rethrow;
    }
  }

  // استرجاع برامج مركز تكوين (GET /training_centers/:id/programs)
  Future<List<CourseOpportunityModel>> fetchCenterPrograms(String centerId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/training_centers/$centerId/programs'),
        headers: {
          'Authorization': token,
        },
      );

      print('Fetch Center Programs Response - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CourseOpportunityModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('مركز التكوين غير موجود');
      } else if (response.statusCode == 500) {
        throw Exception('خطأ في الخادم');
      } else {
        throw Exception('Failed to load center programs: ${response.body}');
      }
    } catch (e) {
      print('Error fetching center programs: $e');
      rethrow;
    }
  }

  // استرجاع جميع برامج التدريب (GET /training_programs)
  Future<List<Map<String, dynamic>>> fetchApplications(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/training_programs'),
        headers: {
          'Authorization': token,
        },
      );

      print('Fetch Applications Response - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else if (response.statusCode == 500) {
        throw Exception('خطأ في الخادم');
      } else {
        throw Exception('Failed to load applications: ${response.body}');
      }
    } catch (e) {
      print('Error fetching applications: $e');
      rethrow;
    }
  }

  // إنشاء برنامج تدريبي (POST /training_programs)
// إنشاء برنامج تدريبي (POST /training_programs)
  Future<bool> createOpportunity(CreateOpportunityRequest opportunity, File? image, String token) async {
    try {
      if (token.isEmpty) {
        throw Exception('رمز التوثيق غير صالح أو غير موجود');
      }

      var uri = Uri.parse('https://tamkeens.up.railway.app/training_programs');
      var response = await http.post(
        uri,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(opportunity.toMap()),
      );

      print('Create Opportunity Response - Status: ${response.statusCode}, Body: ${response.body}');
      print('🧾 Request Body: ${jsonEncode(opportunity.toMap())}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        throw Exception('فقط مراكز التدريب يمكنها إنشاء برامج تدريبية');
      } else if (response.statusCode == 404) {
        throw Exception('مركز التدريب غير موجود');
      } else if (response.statusCode == 500) {
        throw Exception('خطأ في الخادم');
      } else {
        throw Exception('فشل في إنشاء البرنامج التدريبي: ${response.body}');
      }
    } catch (e) {
      print('Error creating opportunity: $e');
      rethrow;
    }
  }



  // حذف برنامج تدريبي (DELETE /training_programs/:id)
  Future<bool> deleteOpportunity(String opportunityId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/training_programs/$opportunityId'),
        headers: {
          'Authorization': token,
        },
      );

      print('Delete Opportunity Response - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('البرنامج التدريبي غير موجود');
      } else if (response.statusCode == 500) {
        throw Exception('خطأ في الخادم');
      } else {
        throw Exception('Failed to delete opportunity: ${response.body}');
      }
    } catch (e) {
      print('Error deleting opportunity: $e');
      rethrow;
    }
  }

  // تحديث حالة طلب (PUT /training_programs/:id)
  Future<bool> updateApplicationStatus(String applicationId, String status, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/training_programs/$applicationId'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );

      print('Update Application Status Response - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        throw Exception('فقط مسؤولو التدريب يمكنهم تحديث برامج تدريب');
      } else if (response.statusCode == 404) {
        throw Exception('مركز التدريب أو البرنامج التدريبي غير موجود');
      } else if (response.statusCode == 500) {
        throw Exception('خطأ في الخادم');
      } else {
        throw Exception('Failed to update application status: ${response.body}');
      }
    } catch (e) {
      print('Error updating application status: $e');
      rethrow;
    }
  }

  // الوظائف القديمة (محتفظ بها للتوافق)
  Future<List<CourseOpportunityModel>> fetchOpportunities() async {
    final token = (await LocalStorageService.getLoginData())?['token'];
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse('$_baseUrl/center/opportunities'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['opportunities'] as List)
            .map((json) => CourseOpportunityModel.fromJson(json))
            .toList();
      }
    }
    throw Exception('Failed to load opportunities');
  }

  Future<bool> updateOpportunity(CourseOpportunityModel opportunity) async {
    final token = (await LocalStorageService.getLoginData())?['token'];
    if (token == null) throw Exception('No authentication token found');

    final response = await http.put(
      Uri.parse('$_baseUrl/center/opportunities/${opportunity.id}'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'courseTitle': opportunity.courseTitle,
        'startDate': opportunity.startDate,
        'domain': opportunity.domain,
        'description': opportunity.description,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    }
    throw Exception('Failed to update opportunity');
  }

  Future<List<Map<String, dynamic>>> fetchApplicationsOld() async {
    final token = (await LocalStorageService.getLoginData())?['token'];
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse('$_baseUrl/center/applications'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['applications']);
      }
    }
    throw Exception('Failed to load applications');
  }

  Future<bool> updateApplicationStatusOld(String applicationId, String status) async {
    final token = (await LocalStorageService.getLoginData())?['token'];
    if (token == null) throw Exception('No authentication token found');

    final response = await http.put(
      Uri.parse('$_baseUrl/center/applications/$applicationId/status'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    }
    throw Exception('Failed to update application status');
  }
}
// lib/services/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/User_1/profile_model.dart';

class ProfileService {
  static const String _baseUrl = 'https://your-api.com/api';

  Future<Map<String, dynamic>?> submitProfile(ProfileModel profile) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/profiles'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(profile.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to submit profile: $e');
    }
  }


  Future<String?> uploadFile(String filePath, String fileType) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/upload'),
      );
      request.files.add(await http.MultipartFile.fromPath(fileType, filePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['url']; // غيّر المفتاح حسب الـ API
      }
      return null;
    } catch (e) {
      print("❌ File upload failed: $e");
      return null;
    }
  }

}
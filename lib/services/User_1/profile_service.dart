import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tamkin/models/User_1/profile_model.dart';
import 'package:intl/intl.dart';

class ProfileService {
  static const String _baseUrl = 'https://tamkeens.up.railway.app';

  Future<Map<String, dynamic>?> submitProfile(ProfileModel profile, {required Map<String, String> signupData}) async {
    print('🔍 Starting submitProfile function');
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/signupuser'));
      request.fields.addAll({
        'first_name': profile.firstName,
        'last_name': profile.lastName,
        'email': signupData['email']!,
        'password': signupData['password']!,
        'phone': signupData['phone']!,
        'date_of_birth': DateFormat('yyyy-MM-dd').format(profile.dateOfBirth!),
        'gender': profile.gender ?? '',
        'wilaya': profile.wilaya ?? '',
        'commune': profile.commune,
        'street': profile.street,
        'address': '${profile.street}, ${profile.commune}, ${profile.wilaya}',
        'user_type': 'trainee',
        'education_level': profile.educationLevel ?? '',
        'level_of_education': profile.educationLevel ?? '',
        'interests': profile.interests.isNotEmpty ? profile.interests.join(',') : 'None',
        'skills': profile.skills.isNotEmpty ? profile.skills.join(',') : 'None',
        'receive_notifications': profile.receiveNotifications.toString().toLowerCase(),
      });

      print('📤 Sending data to API: ${request.fields}');

      if (profile.profilePicture != null) {
        request.files.add(await http.MultipartFile.fromPath('profile_picture', profile.profilePicture!));
        print('📤 Added profile picture file: ${profile.profilePicture}');
      }
      if (profile.cv != null) {
        request.files.add(await http.MultipartFile.fromPath('cv', profile.cv!));
        print('📤 Added CV file: ${profile.cv}');
      }
      if (profile.diploma != null) {
        request.files.add(await http.MultipartFile.fromPath('certificate', profile.diploma!));
        print('📤 Added diploma file: ${profile.diploma}');
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Profile submitted successfully!');
        return json.decode(responseBody);
      } else {
        print('❌ Failed to submit profile, status: ${response.statusCode}, error: $responseBody');
        return null;
      }
    } catch (e) {
      print('❌ Error during submission: $e');
      throw Exception('Failed to submit profile: $e');
    }
  }

  Future<String?> uploadFile(String filePath, String fileType) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/upload'));
      request.files.add(await http.MultipartFile.fromPath(fileType, filePath));
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['url'];
      }
      return null;
    } catch (e) {
      print("❌ File upload failed: $e");
      return null;
    }
  }
}

// services/training_center_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/Center_3/Training_Center_Model.dart';


class TrainingCenterServices {
  static const String _baseUrl = 'https://your-api.com/api';

  Future<bool> submitCenter(TrainingCenterModel center) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/training-centers'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(center.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to submit center: $e');
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
        final result = await response.stream.bytesToString();
        return json.decode(result)['url'];
      }
      return null;
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }
}
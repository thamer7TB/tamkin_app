import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/Company_2/company_model.dart';

class CompanyServices {
  static const String _baseUrl = 'https://your-api.com/api';

  /// إرسال بيانات الشركة إلى الخادم
   Future<bool> submitCompanyProfile(CompanyModel company) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/companies'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(company.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Failed to submit company profile: $e');
    }
  }

  /// رفع ملف (شعار الشركة مثلًا)
  static Future<String?> uploadFile(String filePath, String fileType) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/upload'),
      );
      request.files.add(await http.MultipartFile.fromPath(fileType, filePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        final result = await response.stream.bytesToString();
        final data = json.decode(result);
        return data['url']; // ⚠️ تأكد أن API ترجع {"url": "..."}
      }
      return null;
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }
}

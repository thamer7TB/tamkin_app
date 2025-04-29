
import 'dart:convert';
import 'package:http/http.dart' as http;

class CenterService {
  static const String _baseUrl = 'https://your-api.com/api'; // استبدله لاحقاً بالرابط الحقيقي

  // 📥 جلب بيانات مركز التكوين عبر ID
  Future<Map<String, dynamic>?> fetchCenterProfile(String centerId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/centers/$centerId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load center profile. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching center profile: $e');
      return null;
    }
  }
}

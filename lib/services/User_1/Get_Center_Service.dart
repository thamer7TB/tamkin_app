
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../mock/mock_data.dart';
import '../../models/User_1/center_model.dart';


class CenterService {
  static const String _baseUrl = 'https://your-api.com/api';
  final bool useMock = true;

  // جلب قائمة المراكز
  Future<List<CenterModel>> fetchCenters() async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      return mockCentersList; // عدّل mock_data.dart ليحتوي على mockCentersList
    }

    final response = await http.get(Uri.parse('$_baseUrl/centers'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => CenterModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load centers');
  }

  // جلب بيانات المركز بناءً على ID
  Future<Map<String, dynamic>?> fetchCenterProfile(String centerId) async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mockCenters.containsKey(centerId)) {
        print('Center ID $centerId not found in mock data');
        return null;
      }
      return mockCenters[centerId];
    }

    final response = await http.get(Uri.parse('$_baseUrl/centers/$centerId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    print('Failed to load center profile. Status code: ${response.statusCode}');
    return null;
  }
}
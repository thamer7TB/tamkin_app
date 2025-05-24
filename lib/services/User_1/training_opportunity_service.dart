
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../mock/training_mock_data.dart';
import '../../models/User_1/training_opportunity_model.dart';

class TrainingOpportunityService {
  static const String _baseUrl = 'https://your-api.com/api';

  // تبديل بين API و mock
  final bool useMock = true;

  Future<List<TrainingOpportunityModel>> fetchTrainingOpportunities() async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 500)); // محاكاة التأخير
      try {
        print('Fetching mock trainings: ${mockTrainings.length} items');
        if (mockTrainings.isEmpty) {
          print('Warning: mockTrainings is empty');
        }
        return mockTrainings;
      } catch (e) {
        print('Error in mock trainings: $e');
        throw Exception('Error fetching mock trainings: $e');
      }
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl/trainings'));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        print('API trainings fetched: ${data.length} items');
        return data.map((e) => TrainingOpportunityModel.fromJson(e)).toList();
      } else {
        print('API error: Status code ${response.statusCode}');
        throw Exception('Failed to load trainings');
      }
    } catch (e) {
      print('API error: $e');
      throw Exception('Error: $e');
    }
  }
}


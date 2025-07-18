import 'dart:convert';

import 'package:http/http.dart' as http;

class CrimePredictionService {
  final String _baseUrl = 'http://192.168.100.202:8000';

  Future<Map<String, dynamic>> predictCrime({
    required String location,
    required String dayOfWeek,
    required double latitude,
    required double longitude,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/predict');
    final Map<String, dynamic> payload = {
      "location": location,
      "day_of_week": dayOfWeek,
      "latitude": latitude,
      "longitude": longitude,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return {
        'crime_type': data['predicted_crime_group'],
        'probability_distribution': data['probability_distribution'],
      };
    } else {
      throw Exception('Prediction failed: ${response.statusCode}');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

/// Service for handling API calls to Gemini AI
class ApiService {
  static const String _apiKey = AppConstants.apiKey;
  static const String _model = AppConstants.model;
  static const String _baseUrl = AppConstants.apiBaseUrl;

  /// Generate content from Gemini AI
  Future<String> generateContent({
    required String query,
    required String loanType,
  }) async {
    try {
      final url =
          '$_baseUrl/$_model:generateContent?key=$_apiKey';

      final prompt =
          'Loan Type: $loanType\nUser Question: $query\nPlease answer in detail with proper guidance for $loanType. Provide practical advice, key information, and important considerations. Keep the response clear and concise.';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
            'No response received.';
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to generate content: $e');
    }
  }
}


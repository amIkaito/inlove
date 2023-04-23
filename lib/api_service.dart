import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey =
      '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';
  static const String _apiEndpoint =
      'https://api.openai.com/v1/engines/davinci/completions';

  Future<String> getDatePlan(Map<String, String> inputMap) async {
    final dateInfo = inputMap.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
    final prompt = 'デートプラン:\n$dateInfo\nプラン:';
    final response = await getGptResponse(prompt);
    return response;
  }

  Future<String> getLoveAdvice(String problem) async {
    final prompt = '恋愛相談: $problem\nアドバイス:';
    final response = await getGptResponse(prompt);
    return response;
  }

  Future<String> getGptResponse(String prompt) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey'
    };

    final body = jsonEncode({
      'prompt': prompt,
      'max_tokens': 100,
      'n': 1,
      'stop': null,
      'temperature': 0.8,
    });

    final response = await http.post(
      Uri.parse(_apiEndpoint),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final generatedText = jsonResponse['choices'][0]['text'];
      return generatedText.trim();
    } else {
      throw Exception('Failed to load GPT response');
    }
  }
}

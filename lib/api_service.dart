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
    final prompt =
        'あなたはデートプランニングのエキスパートです。以下の情報をもとに、楽しく過ごせるデートプランを3つ提案してください。\n\n$dateInfo\n\nそれぞれのデートプランは、以下の形式で提案してください：\n\n1. デートプラン1の概要:\n  1-1. アクティビティ1:\n  1-2. アクティビティ2:\n  1-3. アクティビティ3:\n\n2. デートプラン2の概要:\n  2-1. アクティビティ1:\n  2-2. アクティビティ2:\n  2-3. アクティビティ3:\n\n3. デートプラン3の概要:\n  3-1. アクティビティ1:\n  3-2. アクティビティ2:\n  3-3. アクティビティ3:';
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
      'max_tokens': 150, // ここを変更アア
      'n': 3,
      'stop': null,
      'temperature': 0.5,
    });

    final response = await http.post(
      Uri.parse(_apiEndpoint),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final generatedText = jsonResponse['choices'][0]['text'];
      print(jsonResponse);
      return generatedText.trim();
    } else {
      throw Exception('Failed to load GPT response');
    }
  }
}

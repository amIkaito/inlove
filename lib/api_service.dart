import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey =
      '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';
  static const String _apiEndpoint =
      'https://api.openai.com/v1/chat/completions';

  Future<String> getDatePlan(Map<String, String> inputMap) async {
    final dateInfo = inputMap.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');

    final List<Map<String, String>> messages = [
      {
        'role': 'system',
        'content':
            'あなたはデートプランニングのエキスパートです。以下の情報をもとに、楽しいデートプランを2つ提案してください。\n\n$dateInfo\n\nそれぞれのデートプランは、以下の形式で提案してください：\n\n'
                'プラン1:\n'
                '  概要:\n'
                '  1つ目の行動:\n'
                '  2つ目の行動:\n'
                '  3つ目の行動:\n\n'
                'プラン2:\n'
                '  概要:\n'
                '  1つ目の行動:\n'
                '  2つ目の行動:\n'
                '  3つ目の行動:\n\n'
      },
      {'role': 'user', 'content': dateInfo}
    ];

    final response = await getGptResponse(messages);
    return response;
  }

  Future<String> getLoveAdvice(String problem) async {
    final List<Map<String, String>> messages = [
      {'role': 'system', 'content': 'あなたは恋愛のエキスパートです。以下の恋愛相談に答えてください。'},
      {'role': 'user', 'content': problem}
    ];

    final response = await getGptResponse(messages);
    return response;
  }

  Future<String> getGptResponse(List<Map<String, String>> messages) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey'
    };

    print('Messages: $messages');

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': messages,
      'max_tokens': 700,
      'temperature': 0.7,
    });

    final response = await http.post(
      Uri.parse(_apiEndpoint),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final generatedText = jsonResponse['choices'][0]['message']['content'];
      return generatedText.trim();
    } else {
      print('Error response: ${response.body}');
      throw Exception('Failed to load GPT response');
    }
  }
}

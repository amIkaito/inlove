import 'package:flutter/material.dart';
import 'api_service.dart';

class DatePlanningInputFields extends StatefulWidget {
  final ApiService apiService;
  final Future<String> Function(Map<String, String>) apiFunction;
  String defaultWeather = '天候：';
  String defaultLocation = '場所：';
  String defaultTemperature = '気温：';
  String defaultAdditionalInfo = 'その他の情報：';

  DatePlanningInputFields({
    required this.apiService,
    required this.apiFunction,
  });

  @override
  _DatePlanningInputFieldsState createState() =>
      _DatePlanningInputFieldsState();
}

class _DatePlanningInputFieldsState extends State<DatePlanningInputFields> {
  TextEditingController _weatherController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _temperatureController = TextEditingController();
  TextEditingController _additionalInfoController = TextEditingController();
  String _outputText = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _weatherController = TextEditingController();
    _locationController = TextEditingController();
    _temperatureController = TextEditingController();
    _additionalInfoController = TextEditingController();
  }

  @override
  void dispose() {
    _weatherController.dispose();
    _locationController.dispose();
    _temperatureController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  String createPrompt(String weather, String location, String temperature,
      String additionalInfo) {
    return 'あなたはデートプランニングのエキスパートです。以下の情報をもとに、楽しく過ごせるデートプランを3つ提案してください。\n\n' +
        '天候: $weather\n' +
        '行きたい場所: $location\n' +
        '気温: $temperature\n' +
        'その他の情報: $additionalInfo\n\n' +
        'それぞれのデートプランは、以下の形式で提案してください：\n\n' +
        '1. デートプラン1の概要\n' +
        '  - アクティビティ1\n' +
        '  - アクティビティ2\n' +
        '  - アクティビティ3\n\n' +
        '2. デートプラン2の概要\n' +
        '  - アクティビティ1\n' +
        '  - アクティビティ2\n' +
        '  - アクティビティ3\n\n' +
        '3. デートプラン3の概要\n' +
        '  - アクティビティ1\n' +
        '  - アクティビティ2\n' +
        '  - アクティビティ3';
  }

  Future<void> _sendRequest(
      Future<String> Function(Map<String, String>) apiFunction) async {
    setState(() {
      _isLoading = true;
    });

    String weather = _weatherController.text;
    String location = _locationController.text;
    String temperature = _temperatureController.text;
    String additionalInfo = _additionalInfoController.text;

    String prompt =
        createPrompt(weather, location, temperature, additionalInfo);

    try {
      final outputText = await widget.apiFunction({"inputText": prompt});
      setState(() {
        _outputText = outputText;
      });
    } catch (error) {
      setState(() {
        _outputText = 'エラーが発生しました。もう一度お試しください。';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '天候:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: TextField(
            controller: _weatherController,
            decoration: InputDecoration(
              isDense: true,
              hintText: '晴れ/曇り/雨/雪 など',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          '場所:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: TextField(
            controller: _locationController,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'デートの場所 (例: 東京タワー)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          '気温:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: TextField(
            controller: _temperatureController,
            decoration: InputDecoration(
              hintText: '気温 (例: 20°C)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'その他の情報:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: TextField(
            controller: _additionalInfoController,
            decoration: InputDecoration(
              hintText: '特別なイベントや趣味など',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () => _sendRequest(widget.apiFunction),
            child: Text('デートプランニングしてもらう'),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Output:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _isLoading
              ? CircularProgressIndicator()
              : Text(
                  _outputText,
                  style: TextStyle(fontSize: 16),
                ),
        ),
      ],
    );
  }
}

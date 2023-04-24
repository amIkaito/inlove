import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:flutter/material.dart';

class DatePlanningInputFields extends StatefulWidget {
  final ApiService apiService;
  final Future<String> Function(Map<String, String>) apiFunction;

  DatePlanningInputFields({
    required this.apiService,
    required this.apiFunction,
  });

  @override
  _DatePlanningInputFieldsState createState() =>
      _DatePlanningInputFieldsState();
}

class _DatePlanningInputFieldsState extends State<DatePlanningInputFields> {
  TextEditingController _maleAgeController = TextEditingController();
  TextEditingController _femaleAgeController = TextEditingController();
  TextEditingController _datePurposeController = TextEditingController();
  TextEditingController _budgetController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _weatherController = TextEditingController();
  TextEditingController _temperatureController = TextEditingController();
  TextEditingController _hobbiesController = TextEditingController();
  TextEditingController _avoidController = TextEditingController();
  TextEditingController _additionalInfoController = TextEditingController();

  String defaultWeather = '天候：';
  String defaultLocation = '場所：';
  String defaultTemperature = '気温：';
  String defaultAdditionalInfo = 'その他の情報：';
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
      String createPrompt) {
  return 'あなたはデートプランニングのエキスパートです。以下の情報をもとに、楽しく過ごせるデートプランを3つ提案してください。\n\n' +
      '男性の年齢: ${_maleAgeController.text}\n' +
      '女性の年齢: ${_femaleAgeController.text}\n' +
      'デートの目的: ${_datePurposeController.text}\n' +
      '予算: ${_budgetController.text}\n' +
      'デートの開始時間: ${_startTimeController.text}\n' +
      'デートの所要時間: ${_durationController.text}\n' +
      '行きたい場所: ${_locationController.text}\n' +
      '天候: ${_weatherController.text}\n' +
      '気温: ${_temperatureController.text}\n' +
      '趣味: ${_hobbiesController.text}\n' +
      'デートで避けたいもの: ${_avoidController.text}\n' +
      'その他の情報: ${_additionalInfoController.text}\n\n' +
      'それぞれのデートプランは、以下の形式で提案してください：\n\n' +
      '1. デートプラン1の概要:\n' +
      '  1-1. アクティビティ1:\n' +
      '  1-2. アクティビティ2:\n' +
      '  1-3. アクティビティ3:\n\n' +
      '2. デートプラン2の概要:\n' +
      '  2-1. アクティビティ1:\n' +
      '  2-2. アクティビティ2:\n' +
      '  2-3. アクティビティ3:\n\n' +
      '3. デートプラン3の概要:\n' +
      '  3-1. アクティビティ1:\n' +
      '  3-2. アクティビティ2:\n' +
      '  3-3. アクティビティ3:\n\n';
}

  void _sendRequest() async {
    setState(() {
      _isLoading = true;
    });

    final inputMap = {
      '男性の年齢': _maleAgeController.text,
      '女性の年齢': _femaleAgeController.text,
      'デートの目的': _datePurposeController.text,
      '予算': _budgetController.text,
      'デートの開始時間': _startTimeController.text,
      'デートの所要時間': _durationController.text,
      '場所': _locationController.text,
      '天候': _weatherController.text,
      '気温': _temperatureController.text,
      '趣味': _hobbiesController.text,
      'デートで避けたいもの': _avoidController.text,
    };

    try {
      final response = await widget.apiService.getDatePlan(inputMap);
      setState(() {
        _outputText = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _outputText = 'エラーが発生しました。再試行してください。';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '天候:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _weatherController,
              decoration: InputDecoration(
                hintText: '晴れ/曇り/雨/雪 など',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '場所:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'デートの場所 (例: 東京タワー)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '気温:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _temperatureController,
              decoration: InputDecoration(
                hintText: '気温 (例: 20°C)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'その他の情報:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _additionalInfoController,
              decoration: InputDecoration(
                hintText: '特別なイベントや趣味など',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '男性の年齢:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _maleAgeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '例: 25',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '女性の年齢:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _femaleAgeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '例: 23',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'デートの目的:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _datePurposeController,
              decoration: InputDecoration(
                hintText: '例: 初デート',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '予算:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '例: 1人あたり 7000円',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'デートの開始時間:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _startTimeController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                hintText: '例: 14:00',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'デートの所要時間:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '例: 4時間',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '趣味:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _hobbiesController,
              decoration: InputDecoration(
                hintText: '映画鑑賞、カフェ巡り、アウトドアなど',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'デートで避けたいもの:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _avoidController,
              decoration: InputDecoration(
                hintText: '過度な運動など',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _sendRequest(),
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
        ),
      ),
    );
  }
}

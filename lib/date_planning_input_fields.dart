import 'package:flutter/material.dart';
import 'api_service.dart';

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
  late TextEditingController _weatherController;
  late TextEditingController _locationController;
  late TextEditingController _temperatureController;
  late TextEditingController _additionalInfoController;
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

  Future<void> _sendRequest(
      Future<String> Function(Map<String, String>) apiFunction) async {
    setState(() {
      _isLoading = true;
    });

    final inputData = {
      '天候': _weatherController.text,
      '場所': _locationController.text,
      '気温': _temperatureController.text,
      'その他の情報': _additionalInfoController.text,
    };

    try {
      final outputText = await apiFunction(inputData);
      setState(() {
        _outputText = outputText;
      });
    } catch (error) {
      setState(() {
        _outputText = 'エラーが発生しました: ${error.toString()}';
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
            onPressed: () => _sendRequest(widget.apiFunction), // ここを修正
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

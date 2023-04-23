import 'package:flutter/material.dart';
import 'api_service.dart';
import 'templates.dart';
import 'date_planning_input_fields.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT Love & Date Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '恋愛相談andデートプランニング'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String _outputText = '';
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  late TabController _tabController;
  TextEditingController _inputController = TextEditingController();
  String _responseText = '';
  String? _selectedLoveAdviceTemplate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _sendRequest(Future<String> Function(String) apiFunction) async {
    setState(() {
      _isLoading = true;
    });

    final inputText = _inputController.text;
    try {
      final outputText = await apiFunction(inputText);
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

//入力フィールド
  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_tabController.index == 0)
          TextField(
            controller: _inputController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '悩んでいることや解決したいことを入力してください',
              border: OutlineInputBorder(),
            ),
          ),
      ],
    );
  }

//テンプレートのドロップダウンメニュー
  Widget _buildTemplateDropdown() {
    return DropdownButton<String>(
      hint: Text("Select template"),
      value: _selectedLoveAdviceTemplate,
      items: loveAdviceTemplates.entries.map((entry) {
        String key = entry.key;
        return DropdownMenuItem<String>(
          value: key,
          child: SelectableText(
            key,
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedLoveAdviceTemplate = newValue;
          _inputController.text = loveAdviceTemplates[newValue] ?? '';
        });
      },
    );
  }

//アウトプットのフィールド
  Widget _buildOutputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Output:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(_responseText),
      ],
    );
  }

//デートプランニングの入力フィールド

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '恋愛相談'),
            Tab(text: 'デートプランニング'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Input:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        _buildInputField(),
                        SizedBox(height: 16),
                        _buildOutputField(),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => _sendRequest(
                      (inputText) => _apiService.getLoveAdvice(inputText)),
                  child: Text('恋愛相談する'),
                ),
              ),
            ],
          ),
          DatePlanningInputFields(
            apiService: _apiService,
            apiFunction: _apiService.getDatePlan,
          ),
        ],
      ),
    );
  }
}

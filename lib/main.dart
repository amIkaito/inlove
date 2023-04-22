import 'package:flutter/material.dart';
import 'api_service.dart';
import 'templates.dart';
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

  Future<void> _sendRequest(Function apiFunction) async {
    String input = _inputController.text;
    if (input.isNotEmpty) {
      setState(() {
        _responseText = 'Loading...';
      });
      try {
        String result = await apiFunction(input);
        setState(() {
          _responseText = result;
        });
      } catch (e) {
        setState(() {
          _responseText = 'Error: $e';
        });
      }
    }
  }

//入力フィールド
  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_tabController.index == 0) _buildTemplateDropdown(),
        TextField(
          controller: _inputController,
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter your love problem or date info',
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
          child: Text(key),
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
      body: Column(
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    _buildInputField(),
                    SizedBox(height: 16),
                    _buildOutputField(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () => _sendRequest(_apiService.getLoveAdvice),
                    child: Text('恋愛相談する'),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _sendRequest(_apiService.getDatePlan),
                    child: Text('デートをプランニングしてもらう'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

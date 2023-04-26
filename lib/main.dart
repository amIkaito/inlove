import 'package:flutter/material.dart';
import 'api_service.dart';
import 'Tabbar/date_planning_input_fields.dart';
import 'Tabbar/love_advice.dart'; // 追加: import LoveAdvicePage

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
          LoveAdvicePage(apiService: _apiService), // 追加: LoveAdvicePageウィジェット
          DatePlanningInputFields(
            apiService: _apiService,
            apiFunction: _apiService.getDatePlan,
          ),
        ],
      ),
    );
  }
}

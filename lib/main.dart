import 'package:flutter/material.dart';
import 'api_service.dart';
import 'Tabbar/date_planning_input_fields.dart';
import 'Tabbar/love_advice.dart'; // 追加: import LoveAdvicePage
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT Love & Date Planner',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        scaffoldBackgroundColor: Colors.pinkAccent,
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
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'DancingScript',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.pinkAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: TextStyle(
            fontFamily: 'DancingScript',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
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

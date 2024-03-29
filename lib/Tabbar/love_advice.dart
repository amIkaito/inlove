import 'package:flutter/material.dart';
import '../api_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoveAdvicePage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT Love & Date Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  final ApiService apiService;

  LoveAdvicePage({required this.apiService});

  @override
  _LoveAdvicePageState createState() => _LoveAdvicePageState();
}

class _LoveAdvicePageState extends State<LoveAdvicePage>
    with SingleTickerProviderStateMixin {
  String _outputText = '';
  bool _isLoading = false;
  TextEditingController _inputController = TextEditingController();
  String _responseText = '';
  String? _selectedLoveAdviceTemplate;
  late TabController _tabController; // この行を追加
  bool _loading = false;

  Map<String, String> loveAdviceTemplates = {
    'アプローチ方法についての相談':
        '相談内容: アプローチ方法\n好きな人の性格や関係性: [入力してください]\n現在のアプローチ方法: [入力してください]\n自分の性格や特徴: [ユーザー入力]\n質問: このアプローチ方法で大丈夫ですか？他に何かアドバイスがありますか？',
    'うまくいっていない恋愛についての相談':
        '相談内容: 恋愛の悩み\n彼女との関係性: [入力してください]\nうまくいっていない理由や状況: [入力してください]\nこれまでに試した対処法: [ユーザー入力]\n質問: どのように改善すればうまくいくと思いますか？具体的なアドバイスが欲しいです。',
    '職場での恋愛についての相談':
        '相談内容: 職場での恋愛\n好きな同僚の性格や関係性: [入力してください]\n職場の恋愛に対する方針: [入力してください]\n自分の性格や特徴: [ユーザー入力]\n質問: 職場での恋愛を進めるべきですか？注意点やアドバイスはありますか？',
    '長距離恋愛についての相談':
        '相談内容: 長距離恋愛\n現在の恋人との距離や状況: [入力してください]\n長距離恋愛での悩みや課題: [入力してください]\n自分の性格や特徴: [ユーザー入力]\n質問: 長距離恋愛を続けるためにはどのような工夫が必要ですか？具体的なアドバイスが欲しいです。',
    '初デートのプランについての相談':
        '相談内容: 初デートのプラン\nデートの相手の性格や趣味: [入力してください]\n自分の性格や特徴: [入力してください]\n考えているデートプラン: [ユーザー入力]\n質問: このデートプランは適切ですか？他に良いデートプランの提案はありますか？',
    'デート後のフォローアップについての相談':
        '相談内容: デート後のフォローアップ\nデートの内容や相手の反応: [入力してください]\n自分の感想や不安: [入力してください]\n質問: デート後のフォローアップはどのように行うべきですか？具体的なアドバイスが欲しいです。',
  };
  // 以前に提供されたコードを追加
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

  Future<void> _sendRequest(
      Future<String> Function(String inputText) requestHandler) async {
    String inputText = _inputController.text.trim();
    if (inputText.isEmpty) return;

    setState(() {
      _loading = true;
    });

    try {
      String outputText = await requestHandler(inputText);
      setState(() {
        _outputText = outputText;
      });
    } catch (e) {
      setState(() {
        _outputText = 'エラーが発生しました。もう一度お試しください。';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: EdgeInsets.all(5),
            child: TextField(
              controller: _inputController,
              minLines: 1,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: "相談内容",
                border: InputBorder.none, // 下線を非表示にする
              ),
            ),
          ),
        ),
        SizedBox(height: 16), // この行を追加
      ],
    );
  }

  Widget _buildOutputField() {
    return Container(
      width: 400,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '恋愛先生',
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 8), // 恋愛先生の名前とローディングインジケータの間にスペースを追加
              if (_loading)
                LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.pinkAccent,
                  size: 22,
                ),
            ],
          ),
          SizedBox(height: 8), // 恋愛先生の名前と回答の間にスペースを追加
          Text(
            _outputText,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateDropdown() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8), // パディングを追加
        decoration: BoxDecoration(
          color: Colors.white, // 背景色を設定
          borderRadius: BorderRadius.circular(30.0), // 角丸を設定
        ),
        child: Center(
          child: DropdownButton<String>(
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            elevation: 16,
            hint: Text(
              "悩みごとを選択してください",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 16,
                fontFamily: 'DancingScript',
              ),
            ),
            value: _selectedLoveAdviceTemplate,
            dropdownColor: Colors.white,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'DancingScript',
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
            ),
            items: loveAdviceTemplates.entries.map((entry) {
              String key = entry.key;
              return DropdownMenuItem<String>(
                value: key,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: SelectableText(
                    key,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'DancingScript',
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedLoveAdviceTemplate = newValue;
                _inputController.text = loveAdviceTemplates[newValue] ?? '';
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 16),
                        _buildTemplateDropdown(), // この行を追加
                        SizedBox(height: 18),
                        _buildInputField(),
                        SizedBox(height: 32),
                        _buildOutputField(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _loading // _loadingがtrueの場合、ボタンを無効化する
                      ? null
                      : () async {
                          await _sendRequest((inputText) =>
                              widget.apiService.getLoveAdvice(inputText));

                          // 相談内容をリセット
                          _inputController.clear();
                        },
                  child: Text('恋愛相談する'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontFamily: 'DancingScript',
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

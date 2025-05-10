import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grad_proj/screen/about_screen/chatbot/question_model.dart';
import 'package:grad_proj/widgets/orgappbar.dart';
import 'package:grad_proj/widgets/text_field_chatbot.dart';
import 'chat_item.dart';
import 'chat_message.dart';
import 'chat_options.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<ChatItem> _messages = [];
  final TextEditingController _controller = TextEditingController();
  Map<String, QuestionModel> _questionMap = {};
  String? _currentQuestionId = 'language_selection';
  @override
  void initState() {
    super.initState();
    _loadQuestionsFromJson();
  }
  Future<void> _loadQuestionsFromJson() async {
    final String response = await rootBundle.loadString(
      'assets/chat_data.json',
    );
    final List<dynamic> data = json.decode(response);

    setState(() {
      _questionMap = {for (var q in data) q['id']: QuestionModel.fromJson(q)};
    });

    _showCurrentQuestion();
  }
  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.insert(
        0,
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
    });
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 500), () {
      _showCurrentQuestion();
    });
  }
  void _showCurrentQuestion() {
    if (_currentQuestionId == null) return;
    final question = _questionMap[_currentQuestionId];
    if (question == null) return;
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: question.question,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _messages.insert(
        0,
        ChatOptions(
          options: question.options.map((o) => o.text).toList(),
          onOptionSelected: _handleOptionSelected,
          timestamp: DateTime.now(),
        ),
      );
    });
  }
  void _handleOptionSelected(String selectedOption) {
    final current = _questionMap[_currentQuestionId];
    final selected = current?.options.firstWhere(
          (o) => o.text == selectedOption,
      orElse: () => OptionModel(text: '', next: ''),
    );
    if (selected == null || selected.next.isEmpty) return;
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: selectedOption,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _currentQuestionId = selected.next;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _showCurrentQuestion();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:Orgappbar(scaffoldKey:scaffoldKey, title: 'Chatbot.title'.tr(),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) => _messages[index],
              ),
            ),
            const SizedBox(height: 16.0),
            TextFieldChatbot(controller: _controller, onSubmitted: _handleSubmitted,),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 6.0),
            //   child: Row(
            //     children: [
            //       Flexible(
            //         child: TextField(
            //           controller: _controller,
            //           onSubmitted: _handleSubmitted,
            //           decoration: InputDecoration(
            //             hintText: 'Ask a question...',
            //             border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(24.0),
            //               borderSide: const BorderSide(
            //                 color: Colors.grey,
            //                 width: 2.0,
            //               ),
            //             ),
            //             focusedBorder: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(20.0),
            //               borderSide: const BorderSide(
            //                 color: Color(0xff2E5077),
            //                 width: 2.0,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.send),
            //         onPressed: () => _handleSubmitted(_controller.text),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

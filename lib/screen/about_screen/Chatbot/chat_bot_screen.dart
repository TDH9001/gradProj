
import 'package:flutter/material.dart';

import 'chat_tree.dart';

import '../../../widgets/orgappbar.dart';
final scaffoldKey = GlobalKey<ScaffoldState>();


class ChatBotScreen extends StatefulWidget {
  static const String id = "ChatBotScreen";

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<ChatNode> _chatHistory = [];
  late ChatNode _currentNode;

  @override
  void initState() {
    super.initState();
    _currentNode = getNodeById(0);
    _chatHistory.add(_currentNode);
  }

  void _handleOptionSelected(int nextNodeId) {
    final newNode = getNodeById(nextNodeId);
    setState(() {
      _currentNode = newNode;
      _chatHistory.add(newNode);
    });
  }

  Widget _buildMessageBubble(ChatNode node) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              node.message,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOptions(List<ChatOption> options) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((option) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
              foregroundColor: Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () => _handleOptionSelected(option.nextNodeId),
            child: Text(option.text),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(scaffoldKey: scaffoldKey , title: "ChatBot",
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
      )),
      
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 16),
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _buildMessageBubble(_chatHistory[index]),
                    if (index == _chatHistory.length - 1)
                      _buildOptions(_currentNode.options),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

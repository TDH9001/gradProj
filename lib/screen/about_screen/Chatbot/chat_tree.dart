import 'package:flutter/material.dart';
import 'package:grad_proj/screen/about_screen/Chatbot/chat_bot_screen.dart';

import '../../../widgets/orgappbar.dart';

class ChatNode {
  final int id;
  final String message;
  final List<ChatOption> options;

  ChatNode({
    required this.id,
    required this.message,
    required this.options,
  });
}

class ChatOption {
  final String text;
  final int nextNodeId;

  ChatOption({
    required this.text,
    required this.nextNodeId,
  });
}

class ChatTree extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
   ChatTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(
        scaffoldKey: scaffoldKey,
        title: " Chat Bot",
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ChatBotScreen()
      ),
    );
  }
}


final Map<int, ChatNode> chatTree = {
  0: ChatNode(
    id: 0,
    message: "Welcome to SciConnect! How can I Help you today?",
    options: [
      ChatOption(text: "type 1", nextNodeId: 1),
      ChatOption(text: "type 2", nextNodeId: 2),
      ChatOption(text: "type 3", nextNodeId: 3),
      ChatOption(text: "type 4", nextNodeId: 4),
    ],
  ),
  
  
  1: ChatNode(
    id: 1,
    message: "type 1:\nWhat would you like to know about type 1?",
    options: [
      ChatOption(text: "Info1", nextNodeId: 5),
      ChatOption(text: "Info2", nextNodeId: 6),
      ChatOption(text: "Info3", nextNodeId: 7),
      ChatOption(text: "Info4", nextNodeId: 8),
      ChatOption(text: "Back", nextNodeId: 0),
    ],
  ),
  5: ChatNode(
    id: 5,
    message: "Info 1:\n we are in info 1 rn now . Need help with info 1 :",
    options: [
      ChatOption(text: "info 1.1", nextNodeId: 9),
      ChatOption(text: "info 1.2", nextNodeId: 10),
      ChatOption(text: "info 1.3", nextNodeId: 11),
      ChatOption(text: "Back", nextNodeId: 1),
    ],
  ),
  6: ChatNode(
    id: 6,
    message: "Info2:\nwe are in info 2 rn now . Need help with info 2.",
    options: [
      ChatOption(text: "info 2.1", nextNodeId: 12),
      ChatOption(text: "info 2.2", nextNodeId: 13),
      ChatOption(text: "info 2.3", nextNodeId: 14),
      ChatOption(text: "Back", nextNodeId: 1),
    ],
  ),
  
  
  2: ChatNode(
    id: 2,
    message: "type 2:\nWhat would you like to know about type 2?",
    options: [
      ChatOption(text: "xxx", nextNodeId: 15),
      ChatOption(text: "yyy", nextNodeId: 16),
      ChatOption(text: "zzz", nextNodeId: 17),
      ChatOption(text: "sss", nextNodeId: 18),
      ChatOption(text: "Back", nextNodeId: 0),
    ],
  ),
  15: ChatNode(
    id: 15,
    message: "blablba:\nwe are in blablaba",
    options: [
      ChatOption(text: "testttting", nextNodeId: 19),
      ChatOption(text: "still testinnnnggg", nextNodeId: 20),
      ChatOption(text: "testing ?", nextNodeId: 21),
      ChatOption(text: "Back", nextNodeId: 2),
    ],
  ),
  
  
  3: ChatNode(
    id: 3,
    message: "not blablba:\nwe are in not blablaba",
    options: [
      ChatOption(text: "dddddd", nextNodeId: 22),
      ChatOption(text: "ccccc", nextNodeId: 23),
      ChatOption(text: "qqqqq", nextNodeId: 24),
      ChatOption(text: "Back", nextNodeId: 0),
    ],
  ),
  
  
  4: ChatNode(
    id: 4,
    message: "scccc:\n sdssd",
    options: [
      ChatOption(text: "Main Menu", nextNodeId: 0),
    ],
  ),
  
 
};


ChatNode getNodeById(int nodeId) {
  return chatTree[nodeId] ?? ChatNode(
    id: -1,
    message: "Sorry, I didn't understand that. Let's start over.",
    options: [ChatOption(text: "Main Menu", nextNodeId: 0)]
  );
}




/*
Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatBotScreen()),
              );
 */

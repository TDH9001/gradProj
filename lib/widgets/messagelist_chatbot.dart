import 'package:flutter/material.dart';
import 'package:grad_proj/features/about_screen/chatbot/chat_item.dart';

class MessagelistChatbot extends StatelessWidget {
  final ScrollController scrollController;

  final List<ChatItem> messages;

  const MessagelistChatbot({super.key, required this.messages, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:
            ListView.builder(
              controller: scrollController,
              reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) => messages[index],

            ),
    );
  }
}

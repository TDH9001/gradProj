import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import 'chat_item.dart';

class ChatMessage extends ChatItem {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required super.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: Color(0xff769BC6),
              child: Image.asset(
                'assets/images/robot.png',
                fit: BoxFit.cover,
              ), // E for Education bot
            ),
          const SizedBox(width: 8.0),
          Flexible(
            child: ChatBubble(
              elevation: 0,
              clipper: ChatBubbleClipper5(
                type:
                isUser ? BubbleType.sendBubble : BubbleType.receiverBubble,
              ),
              alignment: isUser ? Alignment.topRight : Alignment.topLeft,
              margin: const EdgeInsets.only(top: 20),
              backGroundColor:
              isUser ? Color(0xff2E5077) : Colors.grey[200],
              //Colors.grey[200] Color(0xFF8DA8C7)
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 15,
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: isUser ? Colors.white70 : Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

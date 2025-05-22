import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/voice_chat_bubble.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';

class VoiceMessageBaseBAckground extends StatelessWidget {
  const VoiceMessageBaseBAckground(
      {super.key, required this.widget, required this.child});

  final VoiceBubble widget;
  final List<Widget> child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.message.isImportant
              ? Color(0xFFD3E3F1)
              : Colors.grey[300]),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: widget.message.senderID ==
                HiveUserContactCashingService.getUserContactData().id
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: child,
      ),
    );
  }
}

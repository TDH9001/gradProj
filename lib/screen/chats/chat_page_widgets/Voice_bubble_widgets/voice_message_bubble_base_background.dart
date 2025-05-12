import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/voice_chat_bubble.dart';

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
          color: widget.isImportant ? Color(0xFFE7CD78) : Colors.grey.shade400),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment:
            widget.isOurs ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: child,
      ),
    );
  }
}

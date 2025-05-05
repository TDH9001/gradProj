import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/voice_chat_bubble.dart';

class VoiceMessageBaseBAckground extends StatelessWidget {
  const VoiceMessageBaseBAckground(
      {super.key,
      required this.colorScheme,
      required this.widget,
      required this.child});

  final List<Color> colorScheme;
  final VoiceBubble widget;
  final List<Widget> child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: colorScheme,
              stops: [0.40, 0.70],
              begin:
                  widget.isOurs ? Alignment.bottomLeft : Alignment.bottomRight,
              end: widget.isOurs ? Alignment.topRight : Alignment.topLeft)),
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

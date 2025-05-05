import 'package:flutter/material.dart';

class TextfieldChatbot extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  const TextfieldChatbot({super.key, required this.controller, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Flexible(
          child: TextField(
            controller: controller,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: 'Ask a question...',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Color(0xff2E5077), width: 2.0),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => onSubmitted(controller.text),
        ),
      ],
    ),
    );
  }
}

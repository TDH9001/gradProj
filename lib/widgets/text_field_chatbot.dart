import 'package:flutter/material.dart';

class TextFieldChatbot extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  const TextFieldChatbot({super.key, required this.controller, required this.onSubmitted});

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
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Color(0xff2E5077)),
                  onPressed: () => onSubmitted(controller.text),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(color: Color(0xff2E5077), width: 2.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


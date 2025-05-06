import 'package:flutter/material.dart';

import 'chat_item.dart';

class ChatOptions extends ChatItem {
  final List<String> options;
  final Function(String) onOptionSelected;

  const ChatOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
    required super.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timestamp
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          // Options
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: options
                .map(
                  (option) => ChoiceChip(
                    backgroundColor: Color(0xFF4A739F),
                label: Text(option , style: const TextStyle(color: Colors.white)),
                selected: false,
                onSelected: (selected) => onOptionSelected(option),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

abstract class ChatItem extends StatelessWidget {
  final DateTime timestamp;

  const ChatItem({super.key, required this.timestamp});
}

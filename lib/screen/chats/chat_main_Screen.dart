import 'package:flutter/material.dart';
import '../../services/navigation_Service.dart';
import '../../services/snackbar_service.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({super.key});
  static String id = "ChatMainScreen";
  @override
  State<ChatMainScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ChatMainScreen> {
  @override
  Widget build(BuildContext _context) {
    SnackBarService.instance.buildContext = _context;
    return Scaffold(
      body: ListView(
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/screen/Profile_screen.dart';

class ChatTabsScreen extends StatefulWidget {
  const ChatTabsScreen({super.key});

  @override
  State<ChatTabsScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ChatTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabcont;

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  @override
  void initState() {
    super.initState();
    _tabcont = TabController(
      length: myTabs.length,
      initialIndex: 1,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(controller: _tabcont, tabs: [
          Tab(
              icon: Icon(
            Icons.person_outlined,
            size: 25,
          ))
        ]),
      ),
      body: Container(
        child: TabBarView(
          controller: _tabcont,
          children: myTabs,
        ),
      ),
    );
  }
}

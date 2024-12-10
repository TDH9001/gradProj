import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:grad_proj/screen/chats_and_profile/chat_tabs_screen.dart';
import 'package:grad_proj/screen/chats_and_profile/chat_main_Screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';
import 'navbar_screen.dart';
import 'orgappbar.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  static String id = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> screens = [
    Container(
      child: Center(
        child: Text("Home"),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: NavbarScreen(),
      appBar: Orgappbar(
        scaffoldKey: scaffoldKey,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
              backgroundColor: Color(0xff7AB2D3),
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Color(0xff7AB2D3),
              gap: 8,
              onTabChange: (index) {
                print(index);
              },
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  onPressed: () {
                    print("palceHolder");
                  },
                  icon: Icons.chat,
                  text: "Chat",
                ),
                GButton(
                  icon: Icons.table_view,
                  text: "Table",
                ),
              ]),
        ),
      ),
    );
  }
}

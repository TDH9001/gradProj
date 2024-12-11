import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:grad_proj/screen/chats/chats_screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';
import 'package:grad_proj/services/navigation_Service.dart';
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
  int selectedIndex = 0;
  List<Widget> screens = [
    Container(
      child: Center(
        child: Text("Home"),
      ),
    ),
    TableScreen(),
    Container(
      child: Center(
        child: Text("Table"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RecentChats(),
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
                if (index == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text("Chat"),
                                ),
                              )));
                }
                if (index == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TableScreen()));
                }
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
                    navigationService.instance.navigateTo(RecentChats.id);
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

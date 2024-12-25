import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chats_screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';
import 'package:grad_proj/screen/table/table_screen.dart';
import 'home/home_screen.dart';
import 'account/account_screen.dart';
import 'orgappbar.dart';

class BottomNavegationBarScreen extends StatefulWidget {
  BottomNavegationBarScreen({super.key});

  static String id = "HomeScreen";

  @override
  State<BottomNavegationBarScreen> createState() => _BottomNavegationBarScreenState();
}

class _BottomNavegationBarScreenState extends State<BottomNavegationBarScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    RecentChats(),
    TableScreen(),
    AccountScreen(),
  ];
  final List<String> appBarTitles = [
    'Home',
    'Chats',     // Title for RecentChats()// Title for NavbarScreen()
    'Table',
    'Account'// Title for TableScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(scaffoldKey: scaffoldKey,title: '${appBarTitles[currentIndex]}',),
      body: screens[currentIndex],
      //drawer: NavbarScreen(),
      bottomNavigationBar: CurvedNavigationBar(
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.chat,
            size: 30,
            color: Colors.white,
          ),

          Icon(
            Icons.table_view_outlined,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ],
       color: Color(0xff7AB2D3),
        backgroundColor: Colors.white10,
        buttonBackgroundColor: Color(0xffB9E5E8),
        //backgroundColor: Color(0xff7AB2D3),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            currentIndex = index;

          });
        },
      ),
    );
  }
}

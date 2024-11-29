import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:grad_proj/screen/orgappbar.dart';
import 'navbar_screen.dart';
import 'orgappbar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
       appBar:Orgappbar(scaffoldKey: scaffoldKey,),
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
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
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

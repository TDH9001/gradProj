import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'home_screen.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/Profile_screen.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';

class NavbarScreen extends StatelessWidget {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "Ain Shams University",
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                "science faculty",
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/AinShamsUniv.png',
                  ),
                ),
              ),
              decoration: BoxDecoration(color: Color(0xff7AB2D3)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () => print("Home Tapped"),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                print("Profile Tapped");
                navigationService.instance.navigateTo(ProfileScreen.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("Chatting"),
              onTap: () => print("Chatting Tapped"),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
              onTap: () => print("Notification Tapped"),
            ),
           ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutScreen()))),

          ],
        ),
      ),
    );
  }
}

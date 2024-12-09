import 'package:flutter/material.dart';
import 'home_screen.dart';

class NavbarScreen extends StatelessWidget {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              "Ain Shams University",
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: const Text(
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
            decoration: const BoxDecoration(color: Color(0xff7AB2D3)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () => print("Profile Tapped"),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {},
          ),
          // ListTile(
          //   leading: const Icon(Icons.chat),
          //   title: const Text("Chatting"),
          //   onTap: () => print("Chatting Tapped"),
          // ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () => print("Notification Tapped"),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => print("Logout Tapped"),
          )
        ],
      ),
    );
  }
}

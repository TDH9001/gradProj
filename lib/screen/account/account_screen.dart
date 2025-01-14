import 'package:flutter/material.dart';
import 'package:grad_proj/settings/setting.dart';
import '../../UI/colors.dart';
import '../about_screen/about_screen.dart';
import '../bottom_navegation_bar_screen.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/profiles/Profile_screen.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  // AuthProvider _auth = AuthProvider();

  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: ColorsApp.primary,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/AinShamsUniv.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Ain Shams University",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "science faculty",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 8),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person,
                              color: Color(0xff769BC6)),
                          title: const Text("Profile",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () {
                            print("Profile Tapped");
                            navigationService.instance
                                .navigateTo(ProfileScreen.id);
                          },
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.settings,
                              color: Color(0xff769BC6)),
                          title: const Text("Settings",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () => navigationService.instance
                              .navigateTo(SettingScreen.id),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Card(
                    //   elevation: 4,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //         colors: [Colors.blue.shade50, Colors.white],
                    //         begin: Alignment.topLeft,
                    //         end: Alignment.bottomRight,
                    //       ),
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //     child: ListTile(
                    //       leading: const Icon(Icons.chat, color: Color(0xff7AB2D3)),
                    //       title: const Text("Chatting", style: TextStyle(fontWeight: FontWeight.bold)),
                    //       onTap: () => print("Chatting Tapped"),
                    //       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.notifications,
                              color: Color(0xff769BC6)),
                          title: const Text("Notifications",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () => print("Notification Tapped"),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading:
                              const Icon(Icons.info, color: Color(0xff769BC6)),
                          title: const Text("About",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () => navigationService.instance
                              .navigateTo(AboutScreen.id),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.logout,
                              color: Color(0xff769BC6)),
                          title: const Text("Logout",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () {
                            _auth.signOut();
                            navigationService.instance
                                .navigateTo(LoginScreen.id);
                          },
                          trailing: const Icon(Icons.logout, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

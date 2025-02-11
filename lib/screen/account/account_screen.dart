import 'package:flutter/material.dart';
import 'package:grad_proj/settings/setting.dart';
import '../../UI/colors.dart';
import '../../widgets/custom_card.dart';
import '../about_screen/question_screen.dart';
import '../../widgets/bottom_navegation_bar_screen.dart';
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
                    CustomCard(
                      icon: Icons.person,
                      title: "Profile",
                      onTap: () {
                        print("Profile Tapped");
                        navigationService.instance.navigateTo(ProfileScreen.id);
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.settings,
                      title: "Settings",
                      onTap: () =>
                          navigationService.instance.navigateTo(SettingScreen.id),
                    ),
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.notifications,
                      title: "Notifications",
                      onTap: () => print("Notification Tapped"),
                    ),
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.question_mark_outlined,
                      title: "Questions",
                      onTap: () => navigationService.instance.navigateTo(AboutScreen.id),
                    ),
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {
                        _auth.signOut();
                        navigationService.instance.navigateTo(LoginScreen.id);
                      },
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

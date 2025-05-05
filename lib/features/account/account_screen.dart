import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/theme/dark_theme_colors.dart';
import '../../theme/light_theme.dart';
import '../../theme/theme_provider.dart';
import '../../widgets/custom_card.dart';
import '../about_screen/question_screen.dart';
import '../../widgets/bottom_navegation_bar_screen.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/features/profiles/Profile_screen.dart';
import 'package:grad_proj/features/auth/login_screen.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';
import '../setting_screen/setting.dart';
class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  // AuthProvider _auth = AuthProvider();
  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<AuthProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
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
                  color: isDarkMode?DarkThemeColors.background:LightTheme.primary,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 35,
                       backgroundColor: isDarkMode ?  DarkThemeColors.background:LightTheme.backimg,
                        child: ClipOval(
                          child: Image.asset('assets/images/AinShamsUniv.png', fit: BoxFit.cover,),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ain_shams_university'.tr(), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,
                        ),),
                      Text(
                        "faculty_of_science".tr(),
                        style: TextStyle(color: isDarkMode?Colors.grey[400]:Colors.white, fontSize: 14,),),],
                  ),),),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.person, title: "card_profile".tr(),
                      onTap: () {
                        navigationService.instance.navigateTo(ProfileScreen.id);
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.settings,
                      title: "card_settings".tr(),
                      onTap: () => navigationService.instance.navigateTo(Setting.id),
                    ),
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.notifications, title: "Notifications", onTap: () => print("Notification Tapped"),),
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.question_mark_outlined,
                      title: "card_questions".tr(),
                      onTap: () => navigationService.instance.navigateTo(QuestionScreen.id),
                    ),
                    const SizedBox(height: 8),
                    CustomCard(icon: Icons.logout, title: "card_logout".tr(),
                      onTap: () {_auth.signOut();navigationService.instance.navigateTo(LoginScreen.id);},),
                  ],
                ),),
            ],
          ),),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/about_screen/acadimic_career_screen.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/custom_card.dart';
import '../about_screen/question_screen.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/profiles/Profile_screen.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';
import '../pdf/student_guide_screen.dart';
import '../setting_screen/setting.dart';
import '../theme/dark_theme_colors.dart';
import '../theme/light_theme.dart';

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
                height: 140,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? DarkThemeColors.background
                      : LightTheme.primary,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: isDarkMode
                            ? DarkThemeColors.background
                            : LightTheme.backimg,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/AinShamsUniv.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Account.university'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Account.faculty'.tr(),
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.white,
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
                      title:'Account.profile'.tr() ,
                      onTap: () {
                        navigationService.instance.navigateTo(ProfileScreen.id);
                      },
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? DarkThemeColors.arrowColor: LightTheme.secondary,),
                    ),
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.settings,
                      title: 'Account.setting'.tr(),
                      onTap: () => navigationService.instance.navigateTo(Setting.id),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? DarkThemeColors.arrowColor: LightTheme.secondary,),
                    ),
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.question_mark_outlined,
                      title: 'Account.question'.tr(),
                      onTap: () => navigationService.instance.navigateTo(QuestionScreen.id),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? DarkThemeColors.arrowColor: LightTheme.secondary,),
                    ),
                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.picture_as_pdf_outlined,
                      title: 'Account.student_guide'.tr(),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StudentGuideScreen()));},
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? DarkThemeColors.arrowColor: LightTheme.secondary,),
                    ),
                    CustomCard(
                      icon: Icons.school_outlined,
                      title: 'Account.academic Career'.tr(),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AcademicCareerScreen()));},
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? DarkThemeColors.arrowColor: LightTheme.secondary,),
                    ),

                    const SizedBox(height: 8),
                    CustomCard(
                      icon: Icons.logout,
                      title: 'Account.logout'.tr(),
                      onTap: () {
                        _auth.signOut();
                        navigationService.instance.navigateTo(LoginScreen.id);},
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? DarkThemeColors.arrowColor: LightTheme.secondary,),
                    ),
                  ],
                ),),
            ],
          ),
        ),
      ),
    );
  }
}

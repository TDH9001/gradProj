import 'package:flutter/material.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/screen/profiles/CompleteProfile.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/navigation_Service.dart';
import '../theme/light_theme.dart';
import '../../widgets/custom_card.dart'; // تأكد أنك تستورد ملف الكارد

class ProfileScreenUi extends StatefulWidget {
  final double length;
  final double height;
  final TextEditingController Controller;

  const ProfileScreenUi({
    super.key,
    required this.height,
    required this.length,
    required this.Controller,
  });

  @override
  State<ProfileScreenUi> createState() => _ProfileScreenUiState();
}

class _ProfileScreenUiState extends State<ProfileScreenUi> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    final auth = Provider.of<AuthProvider>(context);

    if (auth.user == null) {
      navigationService.instance.navigateToReplacement(LoginScreen.id);
    }

    return StreamBuilder<Contact>(
      stream: DBService.instance.getUserData(auth.user!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}\nPlease update your data.",
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          );
        }

        if (snapshot.data == null) return SizedBox.shrink();

        final userData = snapshot.data;
        bool isComplete = userData?.isComplete ?? false;
        if (userData?.seatNumber == null) isComplete = false;

        return isComplete
            ? ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            CustomCard(
              icon: Icons.person,
              title: "Name: ${userData?.firstName ?? ""}",
              onTap: () {},
            ),
            SizedBox(height: 8),
            CustomCard(
              icon: Icons.email,
              title: "Email: ${auth.user!.email ?? ""}",
              onTap: () {},
            ),
            SizedBox(height: 8),
            CustomCard(
              icon: Icons.badge,
              title: "Seat Number: ${userData?.seatNumber ?? ""}",
              onTap: () {},
            ),
            SizedBox(height: 8),
            CustomCard(
              icon: Icons.phone,
              title: "Phone: ${userData?.phoneNumber ?? ""}",
              onTap: () {},
            ),
            SizedBox(height: 8),
            CustomCard(
              icon: Icons.school,
              title: "Academic Year: ${userData?.year ?? ""}",
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildCoursesList(userData!.classes, isDarkMode),
            const SizedBox(height: 50),
            PrimaryButton(
              buttontext: "Edit Data",
              func: () =>
                  navigationService.instance
                      .navigateTo(CompleteProfile.id),
            ),
          ],
        )
            : CompleteProfile();
      },
    );
  }

  Widget _buildCoursesList(List<String> classes, bool isDarkMode) {
    if (classes.isEmpty) {
      return Center(
        child: Text(
          'No courses enrolled yet.',
          style: TextStyle(
              color: isDarkMode ? Colors.white60 : Colors.grey[600],
              fontSize: 16),
        ),
      );
    }

    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,),
        child: ExpansionTile(
          leading: Icon(Icons.menu_book, color: Color(0xff769BC6)),
          title: Text(
            "Courses Enrolled",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          children: classes
              .map(
                (course) =>
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
                    child: ListTile(
                      leading: Icon(Icons.check_circle_outline,
                          color: Color(0xff769BC6)),
                      title: Text(
                        course,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
          )
              .toList(),
        ),
      ),
    );
  }
}
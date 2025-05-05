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

class ProfileScreenUi extends StatefulWidget {
  final double length;
  final double height;
  final TextEditingController Controller;

  const ProfileScreenUi(
      {super.key,
      required this.height,
      required this.length,
      required this.Controller});

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
        if (userData?.seatNumber == null) {
          isComplete = false;
        }

        return isComplete
            ? ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildTextField("Name", userData?.firstName, isDarkMode),
                  _buildTextField("Email", auth.user!.email, isDarkMode),
                  _buildTextField("seat Number",
                      userData?.seatNumber.toString(), isDarkMode),
                  _buildPhoneField(userData?.phoneNumber, isDarkMode),
                  _buildTextField(
                      "Academic Year", userData?.year.toString(), isDarkMode),
                  _buildCoursesList(userData!.classes, isDarkMode),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    buttontext: "Edit Data",
                    func: () => navigationService.instance
                        .navigateTo(CompleteProfile.id),
                  ),
                ],
              )
            : CompleteProfile();
      },
    );
  }

  Widget _buildTextField(String label, String? value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        enabled: false,
        initialValue: value ?? "",
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDarkMode ? Colors.white54 : Color(0xff7AB2D3)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(String? phoneNumber, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: IntlPhoneField(
        enabled: false,
        initialValue: phoneNumber ?? "",
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        initialCountryCode: 'EG',
        decoration: InputDecoration(
          labelText: "Phone Number",
          labelStyle:
              TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDarkMode ? Colors.white54 : Color(0xff769BC6)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
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
      child: ExpansionTile(
        leading: Icon(Icons.book,
            color: isDarkMode ? Colors.blueAccent : Color(0xff769BC6)),
        title: Text("Courses Enrolled",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        children: classes
            .map(
              (course) => ListTile(
                title: Text(course,
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black)),
              ),
            )
            .toList(),
      ),
    );
  }
}

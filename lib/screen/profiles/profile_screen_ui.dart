import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/screen/profiles/CompleteProfile.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/navigation_Service.dart';
import '../../widgets/custom_card.dart';

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
                    // title: ("'Profile ${userData?.firstName ?? ""}")
                    title:
                        "${'Profile.name'.tr()}: ${userData?.firstName ?? ""}",

                    onTap: () {},
                  ),
                  SizedBox(height: 8),
                  CustomCard(
                    icon: Icons.email,
                    //title:( "Email: ${auth.user!.email ?? ""}").tr(),
                    title: "${'Profile.email'.tr()}: ${auth.user?.email ?? ""}",

                    onTap: () {},
                  ),
                  SizedBox(height: 8),
                  CustomCard(
                    icon: Icons.badge,
                    //title: "Seat Number: ${userData?.seatNumber ?? ""}",
                    title:
                        "${'Profile.seat_number'.tr()}: ${userData?.seatNumber ?? ""}",

                    onTap: () {},
                  ),
                  SizedBox(height: 8),
                  CustomCard(
                    icon: Icons.phone,
                    // title: "Phone: ${userData?.phoneNumber ?? ""}",
                    title:
                        "${'Profile.phone_number'.tr()}: ${userData?.phoneNumber ?? ""}",

                    onTap: () {},
                  ),
                  SizedBox(height: 8),
                  CustomCard(
                    icon: Icons.school,
                    //title: "Academic Year: ${userData?.year ?? ""}",
                    title:
                        "${'Profile.academic_year'.tr()}: ${userData?.year ?? ""}",

                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  _buildCoursesList(userData!.classes, isDarkMode),
                  const SizedBox(height: 50),
                  PrimaryButton(
                    buttontext: 'Profile.edit_data_button'.tr(),
                    func: () => navigationService.instance
                        .navigateTo(CompleteProfile.id),
                  ),
                ],
              )
            : CompleteProfile();
      },
    );
  }

  Widget _buildCoursesList(List<String> classes, bool isDarkMode) {
    // final List<ChatSnipits> classList = await DBService.instance
    //     .getUserChats(HiveUserContactCashingService.getUserContactData().id, "")
    //     .first;
    return StreamBuilder(
      stream: DBService.instance.getUserChats(
          HiveUserContactCashingService.getUserContactData().id, ""),
      builder: (context, _snapshot) {
        var data = _snapshot.data;
        // devtools.log(widget.searchText);

        if (_snapshot.connectionState == ConnectionState.waiting ||
            _snapshot.connectionState == ConnectionState.none) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_snapshot.hasError) {
          return Center(
              child: Text(
                  "Error: ${_snapshot.error} \n please update your data and the data field mising"));
        }
        if (_snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Profile.no_course'.tr(),
              style: TextStyle(
                  color: isDarkMode ? Colors.white60 : Colors.grey[600],
                  fontSize: 16),
            ),
          );
        }

        return Card(
          color: isDarkMode ? Color(0xFF323232) : Colors.white,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              leading: Icon(Icons.menu_book, color: Color(0xff769BC6)),
              title: Text(
                'Profile.course_enroll'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              children: _snapshot.data!
                  .map(
                    (course) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
                        child: ListTile(
                          leading: Icon(Icons.check_circle_outline,
                              color: Color(0xff769BC6)),
                          title: Text(
                            course.chatId,
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black87,
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
      },
    );

  }
}

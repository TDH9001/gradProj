import 'package:flutter/material.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/theme/dark_theme_colors.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/dropdown_select_widget.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../widgets/orgappbar.dart';

class CompleteProfile extends StatefulWidget {
  CompleteProfile({super.key});
  static String id = "CompleteProfile";

  static GlobalKey<FormState> _GK = GlobalKey<FormState>();

  @override
  State<CompleteProfile> createState() => _UpdateUserDataState();
}

class _UpdateUserDataState extends State<CompleteProfile> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<DropdownItem<String>> courses = [
    DropdownItem(label: 'math 101', value: "math101"),
    DropdownItem(label: 'math 102', value: "math102"),
    DropdownItem(label: 'math 103', value: "math103"),
    DropdownItem(label: 'math 105', value: "math105"),
  ];
  final _listController = MultiSelectController<String>();
  final _yearController = TextEditingController();
  final _seatIdController = TextEditingController();

  @override
  Widget build(BuildContext _context) {
    final themeProvider = Provider.of<ThemeProvider>(_context);
    final bool isDarkMode = themeProvider.isDarkMode;
    SnackBarService.instance.buildContext = _context;

    return Scaffold(
      appBar: Orgappbar(scaffoldKey: scaffoldKey, title: "Complete Profile"),
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: Form(
          key: CompleteProfile._GK,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Please register your academic year and courses',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildInfoCard(
                label: "Academic Year",
                child: Universaltextformfield(
                  label: "Academic Year",
                  Password: false,
                  controller: _yearController,
                ),
              ),
              SizedBox(height: 16),
              _buildInfoCard(
                label: "Seat Number",
                child: Universaltextformfield(
                  label: "Seat Number",
                  keaboardType: TextInputType.number,
                  Password: false,
                  controller: _seatIdController,
                ),
              ),
              SizedBox(height: 16),
              _buildInfoCard(
                label: "Courses",
                child: DropdownSelect(
                  data: courses,
                  cont: _listController,
                ),
              ),
              SizedBox(height: 32),
              PrimaryButton(
                buttontext: "Validate and Submit",
                func: () async {
                  if (CompleteProfile._GK.currentState?.validate() ?? false) {
                    final selectedItems = _listController.selectedItems;

                    DBService.instance.completeUserProfile(
                      classes: selectedItems.map((item) => item.value.trim()).toList(),
                      year: int.parse(_yearController.text),
                      userId: HiveUserContactCashingService.getUserContactData().id.trim(),
                      seatNumber: int.parse(_seatIdController.text),
                    );

                    for (int i = 0; i < selectedItems.length; i++) {
                      await DBService.instance.addChatsToUser(
                        HiveUserContactCashingService.getUserContactData().id.trim(),
                        selectedItems[i].value,
                      );
                      await DBService.instance.addMembersToChat(
                        HiveUserContactCashingService.getUserContactData().id.trim(),
                        selectedItems[i].value,
                      );
                    }

                    SnackBarService.instance.showsSnackBarSucces(
                      text: "Profile successfully updated",
                    );

                    navigationService.instance.goBack();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String label, required Widget child}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode ? DarkThemeColors.primary.withOpacity(0.9) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            child,
          ],
        ),
      ),
    );
  }
}

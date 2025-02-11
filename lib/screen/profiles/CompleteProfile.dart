import 'package:flutter/material.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/dropdown_select_widget.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

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
    DropdownItem(label: 'math 105', value: "math 105"),
  ];
  final _Listcontroller = MultiSelectController<String>();
  final _yearController = TextEditingController();

  @override
  Widget build(BuildContext _context) {
    var _auth = Provider.of<AuthProvider>(_context);

    if (_auth.user == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      // appBar: Orgappbar(
      //   scaffoldKey: scaffoldKey,
      //   title: "Course Register",
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () {
      //       Navigator.pop(_context);
      //     },
      //   ),
      // ),
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: Form(
          key: CompleteProfile._GK,
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              SizedBox(height: 200),
              Text('Please register your academic year and courses',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF9CA3AF),
                  )),
              // TextHeader(
              //   largeText: "Course Register ",
              //   littleText: "Please register your academic year and courses",
              //   height: 140,
              // ),
              SizedBox(height: 20),
              _buildInfoCard(
                label: "Academic Year",
                child: Universaltextformfield(
                  label: "Academic Year",
                  Password: false,
                  controller: _yearController,
                ),
              ),
              SizedBox(height: 20),
              _buildInfoCard(
                label: "Courses",
                child: DropdownSelect(
                  data: courses,
                  cont: _Listcontroller,
                ),
              ),
              SizedBox(height: 40),
              PrimaryButton(
                buttontext: "Validate and Submit",
                func: () async {
                  if (CompleteProfile._GK.currentState?.validate() ?? false) {
                    final selectedItems = _Listcontroller.selectedItems;

                    DBService.instance.addUserClasesAndYear(
                      classes: selectedItems
                          .map((item) => item.value.trim())
                          .toList(),
                      year: int.parse(_yearController.text),
                      userId: _auth.user!.uid,
                    );
                    for (int i = 0; i < selectedItems.length; i++) {
                      await DBService.instance.addChatsToUser(
                        _auth.user!.uid,
                        selectedItems[i].value,
                      );
                      await DBService.instance.addMembersToChat(
                        _auth.user!.uid,
                        selectedItems[i].value,
                      );
                    }

                    debugPrint(selectedItems.toString());
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

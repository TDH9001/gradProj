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

class CompleteProfile extends StatefulWidget {
  CompleteProfile({super.key});
  static String id = "CompleteProfile";

  static GlobalKey<FormState> _GK = GlobalKey<FormState>();

  @override
  State<CompleteProfile> createState() => _UpdateUserDataState();
}

class _UpdateUserDataState extends State<CompleteProfile> {
  List<DropdownItem<String>> courses = [
    DropdownItem(label: 'math 101', value: "math101"),
    DropdownItem(label: 'math 102', value: "math102"),
    DropdownItem(label: 'math 103', value: "math103"),
    DropdownItem(label: 'math 105', value: "math 105"),
  ];
  static final _Listcontroller = MultiSelectController<String>();
  static final _yearController = TextEditingController();

  final controller = MultiSelectController();
  @override
  Widget build(BuildContext _context) {
    // final double _DeviceHeight = MediaQuery.of(_context).size.height;
    // final double _DeviceWidth = MediaQuery.of(_context).size.width;
    var _auth = Provider.of<AuthProvider>(_context);
    return Scaffold(
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: Form(
          key: CompleteProfile._GK,
          child: ListView(
            children: [
              TextHeader(
                //height: _DeviceHeight * 0.19,
                largeText: "Course Register ",
                littleText: "Please register your academic year and courses",
                height: 140,
              ),
              SizedBox(
                height: 10,
              ),
              DropdownSelect(
                data: courses,
                cont: _Listcontroller,
              ),
              Universaltextformfield(
                  label: "Academic Year",
                  Password: false,
                  controller: _yearController),
              SizedBox(
                height: 40,
              ),
              PrimaryButton(
                  buttontext: "validate and submit",
                  func: () {
                    if (CompleteProfile._GK.currentState?.validate() ?? false) {
                      final selectedItems = _Listcontroller.selectedItems;

                      DBService.instance.addUserClasesAndYear(
                          classes: selectedItems
                              .map((item) => item.value.trim())
                              .toList(),
                          year: int.parse(_yearController.text),
                          userId: _auth.user!.uid);
                      for (int i = 0; i < selectedItems.length; i++) {
                        DBService.instance.addChatsToUser(
                            _auth.user!.uid, selectedItems[i].value);
                      }

                      debugPrint(selectedItems.toString());
                      navigationService.instance.goBack();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

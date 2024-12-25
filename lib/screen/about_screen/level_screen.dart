import 'package:flutter/material.dart';
import 'package:grad_proj/screen/account/account_screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';

import '../custom_dropdown.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedValue1;
  String? selectedValue2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(scaffoldKey: scaffoldKey),
      drawer: AccountScreen(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                CustomDropdownField<String>(
                  items: ["Level 1", "Level 2", "Level 3", "Level 4", " All Levels"],
                  // example course
                  onChanged: (
                      String? value,
                      ) {
                    setState(() {
                      selectedValue1 = value;
                    });
                  },
                  label: "Select Level",
                  isMandatory: true,
                  hintText: "Choose Level",
                  value: selectedValue1,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomDropdownField<String>(
                  items: ["semester 1", "semester 2",],
                  // example day
                  onChanged: (
                      String? value,
                      ) {
                    setState(() {
                      selectedValue2 = value;
                    });
                  },
                  label: "selecd Semester",
                  isMandatory: true,
                  hintText: "Choose Semester",
                  value: selectedValue2,
                ),
                ],
                ),
        ),
      );
  }
}

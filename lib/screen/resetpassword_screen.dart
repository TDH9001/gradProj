import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/login_screen.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/refactored/resetform_screen.dart';
import '../UI/text_style.dart';

class ResetpasswordScreen extends StatelessWidget {
  ResetpasswordScreen({super.key});
  static String id = "resetPassScreen";
  final TextEditingController t1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 200,
            ),
            Text('Reset Password', style: TextStyles.text),
            const SizedBox(
              height: 5,
            ),
            Text('Please enter your email', style: TextStyles.subtext),
            const SizedBox(
              height: 10,
            ),
            //    ResetformScreen(),
            Universaltextformfield(
                label: "Email", Password: false, controller: t1),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: PrimaryButton(
                buttontext: 'Reset Password',
                func: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

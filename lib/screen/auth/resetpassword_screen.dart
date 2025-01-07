import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/refactored/resetform_screen.dart';
import '../../UI/text_style.dart';
import '../../widgets/customTextField.dart';

class ResetpasswordScreen extends StatelessWidget {
  ResetpasswordScreen({super.key});
  static String id = "resetPassScreen";
  final TextEditingController t1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'New Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                child: Text(
                  'Your new password must be different from previously used password',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Email',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(controller: TextEditingController(),
                hintText: 'Confirm Password',
                isPassword: true,
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: PrimaryButton(
                  buttontext: 'Create New Password',
                  func: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


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
              const SizedBox(height: 32),
              const Text(
                'Create your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Email',
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Password',
                isPassword: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              CustomTextField(controller: TextEditingController(),
                hintText: 'Confirm Password',
                isPassword: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 40),
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
      ),
    );
  }
}


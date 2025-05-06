import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import '../../theme/light_theme.dart';
import '../../widgets/customTextField.dart';

class ResetpasswordScreen extends StatelessWidget {
  ResetpasswordScreen({super.key});
  static String id = "resetPassScreen";

  final TextEditingController t1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LightTheme.backgroundGradient,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Icon(Icons.lock_reset, size: 60, color: Colors.white),
                    const SizedBox(height: 20),
                    Text(
                      'New_pass'.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'pass_require'.tr(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // TextFields in a white card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LightTheme.backgroundGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: t1,
                            hintText: 'Email',
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: TextEditingController(),
                            hintText: 'Password',
                            isPassword: true,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: TextEditingController(),
                            hintText: 'Confirm Password',
                            isPassword: true,
                          ),
                          const SizedBox(height: 30),
                          PrimaryButton(
                            buttontext: 'create_pass'.tr(),
                            func: () {
                              AuthProvider.instance
                                  .sendResetPassword(email: t1.text.trim());
                              navigationService.instance.goBack();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


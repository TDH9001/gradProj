import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/refactored/resetform_screen.dart';
import 'package:provider/provider.dart';
import '../../UI/text_style.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/customTextField.dart';
import '../theme/dark_theme_colors.dart';
import '../theme/light_theme.dart';

class ResetpasswordScreen extends StatelessWidget {
  ResetpasswordScreen({super.key});
  static String id = "resetPassScreen";
  final TextEditingController t1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      body:  Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
        gradient: isDarkMode? DarkThemeColors.backgroundGradient: LightTheme.backgroundGradient,
    ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
               Text(
                'Resetpassword.title'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 70),
               Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 20),
                child: Text(
                  'Resetpassword.pass_required'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                controller: t1,
                hintText: 'Resetpassword.Email'.tr(),
              ),
              // CustomTextField(
              //   controller: TextEditingController(),
              //   hintText: 'Password',
              //   isPassword: true,
              // ),
              // const SizedBox(height: 16),
              // CustomTextField(
              //   controller: TextEditingController(),
              //   hintText: 'Confirm Password',
              //   isPassword: true,
              // ),
              const SizedBox(height: 80),
              PrimaryButton(
                buttontext: 'Resetpassword.reset_button'.tr(),
                func: () {
                  AuthProvider.instance
                      .sendResetPassword(email: t1.text.trim());
                  navigationService.instance.goBack();
                },
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

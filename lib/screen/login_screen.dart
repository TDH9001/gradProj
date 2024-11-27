import 'package:flutter/material.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/refactored/loginform_screen.dart';
import 'package:grad_proj/widgets/singupform_screen.dart';
import 'package:grad_proj/widgets/NavigatorTextButton.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/screen/resetpassword_screen.dart';
import 'package:grad_proj/screen/singup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static String id = "login";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "welcome to the login screen",
            style: TextStyle(fontSize: 22, color: textAndAccent),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const SizedBox(
                height: 190,
              ),
             
              //error was located here >LoginformScreen() has a list view but was not given a size
              //added a temporary sizebox
              Universaltextformfield(
                label: "Email",
                Password: false,
              ),
              Universaltextformfield(
                label: "Password",
                Password: true,
              ),
              const PrimaryButton(
                buttontext: 'Login',
              ),
              const SizedBox(
                height: 10,
              ),
              //cahnged from big button to this
              Navigatortextbutton(
                text: "reset Password ?",
                location: ResetpasswordScreen.id,
              ),
              const SizedBox(width: 5),
              Navigatortextbutton(
                text: "sign up",
                location: SingupScreen.id,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

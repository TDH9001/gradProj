import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/singupform_screen.dart';
import 'package:grad_proj/widgets/NavigatorTextButton.dart';
import 'login_screen.dart';

class SingupScreen extends StatelessWidget {
  const SingupScreen({super.key});
  static String id = "SingupScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          const SingupformScreen(),
          const SizedBox(
            height: 20,
          ),
          Navigatortextbutton(
              text: 'Already have an account ?', location: LoginScreen.id),
        ],
      ),
    );
  }
}

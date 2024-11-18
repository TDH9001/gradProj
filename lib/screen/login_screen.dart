import 'package:flutter/material.dart';
import 'package:grad_proj/screen/loginform_screen.dart';
import 'package:grad_proj/screen/primary_button.dart';
import 'package:grad_proj/screen/resetpassword_screen.dart';
import 'package:grad_proj/screen/singup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome to the Login Screen',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'you must login to'
                      ' continue and access the app',
                      style:
                          TextStyle(fontSize: 8, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SingupScreen()));
                      },
                      child: const Text(
                        'sing up',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                LoginformScreen(),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetpasswordScreen()));
                  },
                  child: Text(
                    'Forget your password ?',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                PrimaryButton(
                  buttontext: 'Login',
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      );
  }
}

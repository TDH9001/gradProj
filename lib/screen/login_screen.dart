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
              SizedBox(
                height: 190,
              ),
              //error was located here >LoginformScreen() has a list view but was not given a size
              //added a temporary sizebox
              SizedBox(width: 200, height: 150, child: LoginformScreen()),
              PrimaryButton(
                buttontext: 'Login',
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetpasswordScreen()));
                  },
                  child: const Text(
                    'Forget your password ?',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                        color: Colors.black),
                  )),
              const SizedBox(
                width: 5,
              ),
              //removed the ROW this was inside
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SingupScreen()));
                  },
                  child: const Text(
                    'sing up',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline),
                  )),
              SizedBox(
                height: 10,
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

import 'package:flutter/material.dart';
import 'package:grad_proj/screen/login_screen.dart';
import 'package:grad_proj/screen/splash_screen.dart';

void main() {
  runApp(homePage());
}

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //changed the main page from   SplashScreen() to  LoginScreen(),
        home: LoginScreen());
  }
}

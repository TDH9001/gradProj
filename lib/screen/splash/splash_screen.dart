import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/onboarding_screen/onboarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String id = "SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),()
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  OnboardingScreen(),
      ),
      );
    },

    );
  }
  Widget build(BuildContext context) {
    return const Scaffold(
    // backgroundColor: Colors.white,
      backgroundColor: Color(0xff769BC6),
      body: Center(
        child: Image(image: AssetImage('assets/images/splash.png')),
      )
    );
  }
}

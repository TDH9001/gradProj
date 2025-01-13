import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/onboarding_screen/onboarding_screen.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';

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
      const Duration(seconds: 4),
      () {
        // navigationService.instance
        //     .navigateToReplacement(OnboardingScreen.id); // OnboardingScreen(),;
      },
    );
  }

  Widget build(BuildContext context) {
    return const Scaffold(
        // backgroundColor: Colors.white,
        backgroundColor: Color(0xff769BC6),
        body: Center(
          child: Image(image: AssetImage('assets/images/splash.png')),
        ));
  }
}

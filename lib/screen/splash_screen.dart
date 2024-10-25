import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()
  {
    super.initState();
    Timer(
      const Duration(seconds: 4),()
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Scaffold(),
      ),
      );
    },

    );
  }
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffC6EAFA),
      body: Center(
        child: Image(image: AssetImage('assets/images/science.png')),
      ),


    );
  }
}

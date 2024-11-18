import 'package:flutter/material.dart';
import 'package:grad_proj/screen/learn1_screen.dart';
import 'package:grad_proj/screen/learn2_screen.dart';
import 'package:grad_proj/screen/learn3_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();
  String buttonText = "Skip";
  String nextButtonText = "Next";

  int currentpageindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      PageView(
        controller: pageController,
        onPageChanged: (index)
        {
          if (index == 2)
          {
            nextButtonText = "finish";
          }
          if (index < 2)
          {
            buttonText = "previous";
            nextButtonText = "Next";
          }
          if (index == 0)
          {
            buttonText = "Skip";
          }
          setState(()
          {
            currentpageindex = index;
          });
        },
        children: [
          Learn1Screen(),
          Learn2Screen(),
          Learn3Screen(),
        ],
      ),
      Container(
        alignment: Alignment(0, 0.8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                if (currentpageindex == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                } else {
                  pageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.linear);
                }
              },
              child: Text(buttonText),
            ),
            SmoothPageIndicator(controller: pageController, count: 3),
            GestureDetector(
              onTap: () {
                if (currentpageindex == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                } else {
                  pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.linear);
                }
              },
              child: Text(nextButtonText),
            ),
          ],
        ),
      )
    ]));
  }
}

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
      appBar: AppBar(
        backgroundColor: Color(0xff7AB2D3),
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/AinShamsUniv.png'),
          radius: 20,
        ),
        actions: [
          CircleAvatar(
            backgroundImage:AssetImage('assets/images/science.png'),
            radius: 20,
          ),
        ],
      ),
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
            ElevatedButton(
              onPressed: () {
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
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: Color(0xff7AB2D3),
              // ),
              child: Text(buttonText,
              ),
            ),
            SmoothPageIndicator(controller: pageController, count: 3),
            ElevatedButton(
              onPressed: () {
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
                      curve: Curves.linear,
                  );
                }
              },
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: Color(0xff7AB2D3),
              // ),
              child: Text(nextButtonText),
            ),
          ],
        ),
      )
    ],),);
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/light_theme.dart';
import '../../widgets/onboarding_item.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = "OnboardingScreen";

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var boardController = PageController();
  final List<Map<String, String>> onbording = [
    {
      'image': 'assets/images/img1.png',
      'title': 'onbording_title1',
      'body': 'onbording_body1',
    },
    {
      'image': 'assets/images/chatting2.png',
      'title': 'onbording_title2',
      'body': 'onbording_body2',
    },
    {
      'image': 'assets/images/table.png',
      'title': 'onbording_title3',
      'body': 'onbording_body3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2E5077),
        // automaticallyImplyLeading: false,
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LightTheme.backgroundGradient,
        //   ),
        // ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,),
            child:  Text('Skip'.tr(), style: TextStyle(color: Color(0xff769BC6))),),
        ],
      ),
      body: Container(
    decoration: const BoxDecoration(
    gradient: LightTheme.backgroundGradient,
    ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                onPageChanged: (index) => setState(() {}),
                itemCount: onbording.length,
                itemBuilder: (context, index) => OnboardingItem(
                  image: onbording[index]['image']!,
                  title: onbording[index]['title']!.tr(),
                  body: onbording[index]['body']!.tr(),
                ),
              ),),
            const SizedBox(height: 40),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.white60,
                    activeDotColor: Color(0xff2E5077),
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 5,),
                  count: onbording.length,
                ),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: const Color(0xff2E5077),
                  onPressed: () {
                    if (boardController.page == onbording.length - 1) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (route) => false,
                      );
                    } else {
                      boardController.nextPage(duration: const Duration(milliseconds: 750), curve: Curves.fastLinearToSlowEaseIn,);
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios,color: Colors.white60,),),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

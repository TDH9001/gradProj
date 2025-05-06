import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/onboarding_item.dart';
import '../auth/login_screen.dart';
import '../theme/dark_theme_colors.dart';
import '../theme/light_theme.dart';

class OnbordingModel {
  final String image;
  final String title;
  final String body;

  OnbordingModel(
      {required this.image, required this.title, required this.body
      });
}

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  static String id = "OnboardingScreen";

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var boardController = PageController();

  List<OnbordingModel> onbording = [
    OnbordingModel(
      image: 'assets/images/img1.png',
      title: 'Welcome to SciConnect',
      body: 'An app that bridges science and communication!'
          ' Explore innovative tools to organize your work,collaborate with peers, and achieve your goals.',
    ),
    OnbordingModel(
      image: 'assets/images/chatting2.png',
      title: 'Seamless Collaboration',
      body:
          'Connect with your team through dedicated chat rooms. Share ideas, discussions, and files all in one place.',
    ),
    OnbordingModel(
      image: 'assets/images/table.png',
      title: 'Smart Task Management',
      body:
          'Use the table feature to manage your projects and daily tasks. Track progress effortlessly and stay productive.',
    ),
  ];
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2E5077),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            child: Text(
              'Skip',
              style: TextStyle(color: Color(0xff769BC6)),
            ),
          ),
        ],
      ),
      body: Container(
         decoration:  BoxDecoration(
         gradient: LightTheme.backgroundGradient,
    ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (index) => setState(() {
                  isLast = index == onbording.length - 1;
                }),
                itemCount: onbording.length,
                itemBuilder: (context, index) => OnboardingItem(
                  image: onbording[index].image,
                  title: onbording[index].title,
                  body: onbording[index].body,),
                ),
              ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.white60,
                    activeDotColor: Color(0xff2E5077),
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5,
                  ),
                  count: onbording.length,
                ),
                Spacer(),
                FloatingActionButton(
                  backgroundColor: Color(0xff2E5077),
                  onPressed: () {
                    if (isLast) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    } else {
                      boardController.nextPage(
                        duration: Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,color: Colors.white60,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget buildBoardingItem(OnbordingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset('${model.image}'),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            '${model.title}',
            style: TextStyle(

              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.0,),
          Text(
            '${model.body}',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          SizedBox(height: 30.0,),
        ],
      );
}

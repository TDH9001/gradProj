import 'package:flutter/material.dart';
import 'package:grad_proj/screen/splash/splash_screen.dart';
import 'package:grad_proj/widgets/primary_button.dart';

class noInternet extends StatelessWidget {
  const noInternet({super.key});
  static String id = "noInternet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(flex: 1),
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/internet2.png"))),
            ),
            PrimaryButton(
                buttontext: "try again",
                func: () async {
                  checkConnection();
                }),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grad_proj/screen/splash/splash_screen.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class noInternet extends StatelessWidget {
  const noInternet({super.key});
  static String id = "noInternet";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
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
                      image: AssetImage("assets/images/internet2.png"),
                          ),
                  ),
              ),
            SizedBox(height: 20),
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

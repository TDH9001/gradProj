import 'package:flutter/material.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/bottom_navegation_bar_screen.dart';
import 'package:grad_proj/screen/onboarding_screen/onboarding_screen.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Determine extends StatelessWidget {
  static String id = "Determine";

  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<AuthProvider>(context, listen: false);

    // Navigate based on user's authentication state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_auth.user == null) {
        navigationService.instance.navigateToReplacement(OnboardingScreen.id);
      } else {
        navigationService.instance
            .navigateToReplacement(BottomNavegationBarScreen.id);
      }
    });

    // Return a temporary loading screen while determining state
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

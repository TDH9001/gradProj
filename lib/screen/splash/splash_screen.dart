import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/about_screen/question_screen.dart';
import 'package:grad_proj/widgets/bottom_navegation_bar_screen.dart';
import 'package:grad_proj/screen/onboarding_screen/onboarding_screen.dart';
import 'package:grad_proj/screen/splash/determine.dart';
import 'package:grad_proj/screen/splash/no_internet_page.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';




Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print("Internet is accessible");
      return true;
    }
  } on SocketException catch (_) {
    print("No internet access");
  } catch (_) {
    print("No internet access");
  }

  return false;
}

Future<void> checkConnection() async {
  bool isConnected = await check();
  if (isConnected) {
    navigationService.instance.navigateToReplacement(Determine.id);
  } else {
    //make a new page for when offline
    navigationService.instance.navigateToReplacement(noInternet.id);
  }
}

Future<bool> check() async {
  var connectResult = await Connectivity().checkConnectivity();
  print("Connectivity result: $connectResult"); // Debug info

  if (connectResult == ConnectivityResult.none) {
    print("No network detected");
    return false;
  }

  // Check for actual internet access
  return await checkInternetConnection();
}

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: 3), () {
        checkConnection();
      });
    });
  }

  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
        // backgroundColor: Colors.white,
        backgroundColor: Color(0xff769BC6),
        body: Center(
          child: Image(image: const AssetImage('assets/images/splash.png'),
            color: null,
            colorBlendMode: null,
          ),
        ));
  }
}

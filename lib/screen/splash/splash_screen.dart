import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/splash/determine.dart';
import 'package:grad_proj/screen/splash/no_internet_page.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/providers/theme_provider.dart';

import '../theme/dark_theme_colors.dart';
import '../theme/light_theme.dart';

Future<bool> checkInternetConnection(List<ConnectivityResult> data) async {
  if (data.contains(ConnectivityResult.none)) {
    print("No network interface at all");
    return false;
  }
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print("Internet is accessible");
      return true;
    }
    // } on SocketException {
    //   print("No internet access");
  } on Exception catch (e) {
    if (e is SocketException) {
      print("No internet access but is connected to a network");
    }
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

  return await checkInternetConnection(connectResult);
}
// Check for actual internet access

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? DarkThemeColors.backgroundGradient
              : LightTheme.backgroundGradient,
        ),
        child: Center(
          child: Image(
            image: const AssetImage('assets/images/splash.png'),
            color: isDarkMode ? Colors.white70 : null,
            colorBlendMode: isDarkMode ? BlendMode.modulate : null,
          ),
        ),
      ),
    );
  }
}

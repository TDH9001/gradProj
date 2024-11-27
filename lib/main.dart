import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/resetpassword_screen.dart';
import 'package:grad_proj/screen/singup_screen.dart';
import 'firebase_options.dart';
import 'package:grad_proj/screen/login_screen.dart';
import 'package:grad_proj/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(homePage());
  print(SingupScreen.id);
}

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          "login": (context) => LoginScreen(),
          "resetPassScreen": (context) => ResetpasswordScreen(),
          "SingupScreen": (context) => SingupScreen(),
        },
        debugShowCheckedModeBanner: false,
        //changed the main page from   SplashScreen() to  LoginScreen(),
        home: LoginScreen());
  }
}

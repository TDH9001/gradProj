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
}

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Sci.Connect",
        //to make light mode we need the data to be stored on the app >then depending on the setting
        //we can make it dark or bright >> isDark?  Brightness.dark : Brightness.light
        theme: ThemeData(
            // theme link z
            // textTheme: TextTheme(),
            brightness: Brightness.light,
            primaryColor: Colors.white, //fromARGB(255, 152, 188, 209)
            hintColor: Color.fromARGB(199, 146, 190, 188),
            scaffoldBackgroundColor:
                Colors.white //fromARGB(199, 146, 190, 188),
            ),
        //darkTheme: ThemeData.dark(),
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

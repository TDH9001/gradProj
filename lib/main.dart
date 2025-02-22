import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/about_screen/question_screen.dart';
import 'package:grad_proj/screen/onboarding_screen/onboarding_screen.dart';
import 'package:grad_proj/screen/profiles/CompleteProfile.dart';
import 'package:grad_proj/screen/profiles/Profile_screen.dart';
import 'package:grad_proj/screen/auth/resetpassword_screen.dart';
import 'package:grad_proj/screen/auth/singup_screen.dart';
import 'package:grad_proj/screen/chats/chats_screen.dart';
import 'package:grad_proj/widgets/bottom_navegation_bar_screen.dart';
import 'package:grad_proj/screen/splash/determine.dart';
import 'package:grad_proj/screen/splash/no_internet_page.dart';
import 'package:grad_proj/settings/setting.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/screen/splash/splash_screen.dart';
import '../providers/auth_provider.dart';
import '../services/navigation_Service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
  ], child: homePage()));
}

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<AuthProvider>(context);
    return MaterialApp(
      navigatorKey: navigationService.instance.navKey, //added the nav service
      title: "Sci.Connect",
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor:
              Color.fromARGB(100, 255, 255, 255), //fromARGB(255, 152, 188, 209)
          hintColor: Color.fromARGB(199, 146, 190, 188),
          scaffoldBackgroundColor: Colors.white //fromARGB(199, 146, 190, 188),
          ),
      //darkTheme: ThemeData.dark(),
      //FIXME: fix the isseus with levels in the ABOUT screens
      //FIXME: make a model for the table
      //FIXME: implement the table screen and its stuff

      //TODO: add logic for user to be added to thier classes after finishing
      //TODO: add local storage to store user current data
      //TODO: make chat be stored localy > then allow acces of images , files
      //TODO: make caht be loaded from DB then from cloud
      //TODO: handle files being added to the chat > probably needs storage
      //TODO: make the audi be laoded froma  file and solve the network crisis

      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        Determine.id: (context) => Determine(),
        "OnboardingScreen": (context) => OnboardingScreen(),
        "login": (context) => LoginScreen(),
        "resetPassScreen": (context) => ResetpasswordScreen(),
        "SingupScreen": (context) => SingupScreen(),
        //home has been replaced by BottomNavegationBarScreen
        "HomeScreen": (context) => BottomNavegationBarScreen(),
        "ProfileScreen": (context) => ProfileScreen(),
        "CompleteProfile": (context) => CompleteProfile(),
        "RecentChats": (context) => RecentChats(),
        "AboutScreen": (context) => AboutScreen(),
        "SettingScreen": (context) => SettingScreen(),
        "noInternet": (context) => noInternet(),
      },
      //make it splash later
      initialRoute: SplashScreen.id,
      debugShowCheckedModeBanner: false,
    );
  }
}

//stopped at 5

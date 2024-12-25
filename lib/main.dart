import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/about_screen/about_screen.dart';
import 'package:grad_proj/screen/profiles/CompleteProfile.dart';
import 'package:grad_proj/screen/Profile_screen.dart';
import 'package:grad_proj/screen/auth/resetpassword_screen.dart';
import 'package:grad_proj/screen/auth/singup_screen.dart';
import 'package:grad_proj/screen/chats/chats_screen.dart';
import 'package:grad_proj/screen/bottom_navegation_bar_screen.dart';
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
    return MaterialApp(
      navigatorKey: navigationService.instance.navKey, //added the nav service
      title: "Sci.Connect",
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white, //fromARGB(255, 152, 188, 209)
          hintColor: Color.fromARGB(199, 146, 190, 188),
          scaffoldBackgroundColor: Colors.white //fromARGB(199, 146, 190, 188),
          ),
      //darkTheme: ThemeData.dark(),
      routes: {
        "login": (context) => LoginScreen(),
        "resetPassScreen": (context) => ResetpasswordScreen(),
        "SingupScreen": (context) => SingupScreen(),
        "HomeScreen": (context) => BottomNavegationBarScreen(),
        "ProfileScreen": (context) => ProfileScreen(),
        "CompleteProfile": (context) => CompleteProfile(),
        "RecentChats": (context) => RecentChats(),
        "AboutScreen": (context) => AboutScreen(),
      },
      initialRoute: LoginScreen.id,
      debugShowCheckedModeBanner: false,
    );
  }
}
//stopped at 5
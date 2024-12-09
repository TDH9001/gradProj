import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chat_main_Screen.dart';
import 'package:grad_proj/screen/resetpassword_screen.dart';
import 'package:grad_proj/screen/singup_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:grad_proj/screen/login_screen.dart';
import 'package:grad_proj/screen/splash_screen.dart';
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
        "ChatMainScreen": (context) => ChatMainScreen(),
      },
      initialRoute: LoginScreen.id,
      debugShowCheckedModeBanner: false,
    );
  }
}
//stopped at 5